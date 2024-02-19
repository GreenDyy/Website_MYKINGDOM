using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;
using Microsoft.Ajax.Utilities;
using System.Data.SqlTypes;
using System.Configuration;
using System.Reflection;
using System.Runtime.Remoting.Metadata.W3cXsd2001;
using System.Web.Helpers;
using System.Web.Services.Description;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Web_MYKINGDOM.Controllers
{
    public class OrderController : Controller
    {
        MYKINGDOMEntities db = new MYKINGDOMEntities();
        // GET: Order
        public ActionResult Index()
        {
            return View();
        }
        //load lên view thanh toán là load từ khách hàng và giỏ hàng của mày, khi nào xog xui hết rồi thì mới tạo DonHang va ChiTietDonhang
        [HttpGet]
        public ActionResult ThanhToan()
        {
            int makh = 1;
            if (Session["IDUser"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            else
            {
                makh = (int)Session["IDUser"];
                var vm = new ThongTinKhachHangVaGioHangViewData();
                int magiohang = db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == makh).MaGioHang;

                vm.chiTietGioHangs = db.ChiTietGioHangs.Where(ctgh => ctgh.MaGioHang == magiohang).ToList();

                vm.khachHang = db.KhachHangs.FirstOrDefault(kh => kh.MaKhachHang == makh);
                vm.tenKhachHang = vm.khachHang.HoTenDem + " " + vm.khachHang.Ten;

                return View(vm);
            }
        }

        [HttpPost]
        public ActionResult ThanhToan(string ghichu)
        {
            decimal thanhTien = 0;
            int makh = (int)Session["IDUser"];
            int magh = db.GioHangs.FirstOrDefault(g => g.MaKhachHang == makh).MaGioHang;
            bool checkLoiSoLuong = true;
            List<int?> listMaSanPhamLoiSoLuong = new List<int?>();
            //truy xuất các sp trong giỏ hàng của khách
            var ctghs = db.ChiTietGioHangs.Where(g => g.MaGioHang == magh).ToList();

            //----------------------------------------------------------------- XỬ LÝ NẾU CÓ NHIỀU NGƯỜI MUA CÙNG LÚC -------------------------------------------------------------------

            //kiểm tra có sp nào triong giỏ mà lỗi số lượng ko (nhiều hơn trong kho có)
            foreach (var spTrongCTGH in ctghs)
            {
                var spKho = db.KhoHangs.FirstOrDefault(kh => kh.MaSanPham == spTrongCTGH.MaSanPham);

                if (spKho.SoLuongTonKho < spTrongCTGH.SoLuong)
                {
                    TempData["LoiThanhToan"] = "Sản phẩm hiện tại đã hết hàng, vui lòng kiểm tra lại";
                    //phát hiện lỗi số lượng thì xoá ctgh đó ngay lập tức
                    var gioHang = db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == makh);
                    gioHang.TongSoLuongSP -= spTrongCTGH.SoLuong;
                    Session["CartQuantity"] = gioHang.TongSoLuongSP; // cập nhật số lượng sp trong giỏ hàng

                    listMaSanPhamLoiSoLuong.Add(spTrongCTGH.MaSanPham);
                    checkLoiSoLuong = false;
                }
            }

            if (!checkLoiSoLuong)
            {
                string errorString = "";
                List<SanPham> listSanPhamBiLoi = new List<SanPham>();

                foreach (var masp in listMaSanPhamLoiSoLuong)
                {
                    //xoá sản phẩm lỗi số lượng ra khỏi giỏ hàng
                    var ctgh = db.ChiTietGioHangs.FirstOrDefault(gh => gh.MaSanPham == masp);
                    db.ChiTietGioHangs.Remove(ctgh);
                }
                db.SaveChanges();
                foreach (var masp in listMaSanPhamLoiSoLuong)
                {
                    //hiển thị thông tin sản phẩm bị gỡ
                    var spLoi = db.SanPhams.FirstOrDefault(sp => sp.MaSanPham == masp);
                    listSanPhamBiLoi.Add(spLoi);
                    errorString += spLoi.TenSanPham + "<br>";
                }
                TempData["GioHangThayDoi"] = "Một vài sản phẩm đã bị xoá khỏi giỏ hàng của bạn do kho không đủ số lượng hoặc đã hết hàng:<br>" + errorString;
                return RedirectToAction("Cart", "Cart");
            }
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            using (var transaction = db.Database.BeginTransaction())
            {
                try
                {
                    //trừ số lượng sản phẩm trong KHO đối với từng mặt hàng sau khi mua
                    foreach (var spTrongCTGH in ctghs)
                    {
                        var spKho = db.KhoHangs.FirstOrDefault(kh => kh.MaSanPham == spTrongCTGH.MaSanPham);
                        spKho.SoLuongTonKho -= spTrongCTGH.SoLuong;
                    }

                    // Tính tổng tiền
                    decimal soTienDaGiam = 0;
                    decimal tongTienTatCa = 0;
                    decimal voucherGiam = 0;

                    foreach (var ctgh in ctghs)
                    {
                        tongTienTatCa += (decimal)(ctgh.SanPham.GiaGoc * ctgh.SoLuong);
                        if (Session["DisCount"] != null)
                        {
                            int distCount = (int)Session["DisCount"];
                            voucherGiam = tongTienTatCa * (decimal)(distCount / 100.0);
                        }
                        soTienDaGiam += (decimal)(ctgh.SanPham.GiaGoc * ctgh.SoLuong) - (decimal)(ctgh.SanPham.GiaGiam * ctgh.SoLuong);
                    }
                    thanhTien = tongTienTatCa - soTienDaGiam - voucherGiam;

                    // Thêm đơn hàng mới
                    TaoDonHang(makh, thanhTien, ghichu, ctghs);

                    // Lưu thông tin voucher vào cho khách hàng nếu có dùng
                    if (Session["IDVoucher"] != null)
                    {
                        int mavoucher = (int)Session["IDVoucher"];
                        VoucherKhachHang vc = new VoucherKhachHang();
                        vc.MaKhachHang = makh;
                        vc.MaVoucher = mavoucher;
                        db.VoucherKhachHangs.Add(vc);
                    }

                    //gửi mail cho khách-------------------------------------------------------------------------------
                    string content = System.IO.File.ReadAllText(Server.MapPath("~/TemplateEmail/GuiMail.html"));
                    KhachHang khach = db.KhachHangs.FirstOrDefault(kh => kh.MaKhachHang == makh);
                    var strSanPham = "";
                    strSanPham += "<tr>";
                    strSanPham += "<td style='font-weight: bold;'>" + "Tên sản phẩm" + "</td>";
                    strSanPham += "<td style='font-weight: bold;'>" + "Số lượng" + "</td>";
                    strSanPham += "<td style='font-weight: bold;'>" + "Tổng tiền" + "</td>";
                    strSanPham += "</tr>";

                    foreach (var ctgh in db.ChiTietGioHangs.Where(g => g.MaGioHang == magh).ToList())
                    {
                        strSanPham += "<tr>";
                        strSanPham += "<td>" + ctgh.SanPham.TenSanPham + "</td>";
                        strSanPham += "<td>" + ctgh.SoLuong + "</td>";
                        strSanPham += "<td>" + (ctgh.SoLuong * ctgh.SanPham.GiaGiam).ToString("N0") + " VNĐ" + "</td>";
                        strSanPham += "</tr>";
                    }
                    content = content.Replace("{{TenKhachHang}}", khach.HoTenDem + " " + khach.Ten);
                    content = content.Replace("{{DienThoai}}", khach.SoDienThoai);
                    content = content.Replace("{{Email}}", khach.Email);
                    content = content.Replace("{{DiaChi}}", khach.DiaChi);
                    content = content.Replace("{{NgayDatHang}}", DateTime.Now.ToString("dd/MM/yyyy"));
                    Random rd = new Random();
                    string madonhang = "#DH" + rd.Next(0, 9) + rd.Next(0, 9) + rd.Next(0, 9) + rd.Next(0, 9) + rd.Next(0, 9);
                    content = content.Replace("{{MaDonHang}}", madonhang);
                    content = content.Replace("{{DanhSachSanPham}}", strSanPham);
                    content = content.Replace("{{ThanhTien}}", thanhTien.ToString("N0") + " VNĐ");
                    string subject = "Đơn hàng " + madonhang + " đã đặt thành công";
                    SendEmail(subject, content, khach.Email);

                    // Xóa dữ liệu trong giỏ hàng
                    db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == makh).TongSoLuongSP = 0;
                    Session["CartQuantity"] = 0;
                    foreach (var ctgh in ctghs)
                    {
                        db.ChiTietGioHangs.Remove(ctgh);
                    }

                    db.SaveChanges();
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    // Rollback nếu có lỗi xảy ra
                    transaction.Rollback();
                    TempData["LoiThanhToan"] = ex;
                    return RedirectToAction("ThanhToanThatBai", "Order");
                }
            }

            //xoá session Voucher ko dùng nữa
            Session.Remove("DisCount");
            Session.Remove("IDVoucher");
            return RedirectToAction("ThanhToanThanhCong");
        }

        private void SendEmail(string subject, string content, string EmailTo)
        {
            string emailTo = EmailTo;  // Địa chỉ email người nhận
            string emailFrom = ConfigurationManager.AppSettings["Email"];  // Lấy địa chỉ email từ web.config

            MailMessage mail = new MailMessage(emailFrom, emailTo);
            mail.Subject = subject;
            MailAddress fromAddress = new MailAddress(emailFrom, "MYKINGDOM");
            mail.From = fromAddress;
            mail.To.Add(emailTo);
            mail.Subject = subject;
            mail.IsBodyHtml = true;
            mail.Body = content;

            // Cấu hình SmtpClient
            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com");
            smtpClient.Port = 587;

            smtpClient.Credentials = new NetworkCredential(emailFrom, ConfigurationManager.AppSettings["PasswordEmail"]);
            smtpClient.EnableSsl = true;

            // Gửi email
            smtpClient.Send(mail);
        }

        private void TaoDonHang(int makh, decimal thanhTien, string ghichu, List<ChiTietGioHang> ctghs)
        {
            DonHang donHang;
            if (Session["IDVoucher"] != null) //kt xem khách này lúc mua hàng có dùng voucher ko
            {
                int idVoucher = (int)Session["IDVoucher"];
                donHang = new DonHang
                {
                    MaKhachHang = makh,
                    NgayDatHang = DateTime.Now,
                    TongTien = thanhTien,
                    MaVoucher = idVoucher,
                    TrangThai = "Đang Chờ Xử Lý",
                    GhiChu = ghichu
                };
                db.DonHangs.Add(donHang);
            }
            else
            {
                donHang = new DonHang
                {
                    MaKhachHang = makh,
                    NgayDatHang = DateTime.Now,
                    TongTien = thanhTien,
                    TrangThai = "Đang Chờ Xử Lý",
                    GhiChu = ghichu
                };
                db.DonHangs.Add(donHang);
            }
            foreach (var ctgh in ctghs)
            {
                ChiTietDonHang ctdh = new ChiTietDonHang
                {
                    MaDonHang = donHang.MaDonHang,
                    MaSanPham = ctgh.MaSanPham,
                    SoLuong = ctgh.SoLuong
                };
                db.ChiTietDonHangs.Add(ctdh);
            }
        }


        [HttpGet]
        public ActionResult ThanhToanNgay(int? masanpham, int? soluong)
        {
            if (masanpham == null || soluong == null)
            {
                return RedirectToAction("Index", "Home");
            }

            //kiểm tra số lượng thêm so với số lượng trong kho
            var soLuongTrongKho = db.KhoHangs.FirstOrDefault(kh => kh.MaSanPham == masanpham).SoLuongTonKho;
            if (soluong > soLuongTrongKho)
            {
                TempData["CanhBao"] = "Không đủ số lượng trong kho";
                Session["CanhBao"] = "Không đủ số lượng trong kho";
                return RedirectToAction("ChiTietSanPham", "Product", new { masanpham });
            }

            int makh = 1;
            if (Session["IDUser"] != null)
            {
                makh = (int)Session["IDUser"];
            }
            var vm = new ThanhToanNgayDataView();


            vm.khachHang = db.KhachHangs.FirstOrDefault(kh => kh.MaKhachHang == makh);
            vm.sanPham = db.SanPhams.FirstOrDefault(sp => sp.MaSanPham == masanpham);

            vm.soLuong = (int)soluong;
            vm.tenKhachHang = vm.khachHang.HoTenDem + " " + vm.khachHang.Ten;
            //lưu session để tiến hành thanh toán
            Session["MaSanPham"] = vm.sanPham.MaSanPham;
            Session["SoLuong"] = vm.soLuong;

            return View(vm);
        }

        [HttpPost]
        public ActionResult ThanhToanNgay(string ghichu)
        {
            int masp = (int)Session["MaSanPham"];
            int soluong = (int)Session["SoLuong"];
            int makh = (int)Session["IDUser"];

            SanPham sanPham = db.SanPhams.FirstOrDefault(sp => sp.MaSanPham == masp);

            //tính tổng tiền
            double tongTienTatCa = sanPham.GiaGoc * soluong;
            double soTienDaGiam = tongTienTatCa - (sanPham.GiaGiam * soluong);
            double voucherGiam = 0;
            if (Session["DisCount"] != null)
            {
                int distCount = (int)Session["DisCount"];
                voucherGiam = tongTienTatCa * (distCount / 100.0);
            }
            double thanhTien = tongTienTatCa - soTienDaGiam - voucherGiam;

            DonHang donHang;
            if (Session["IDVoucher"] != null) //kt xem khách này lúc mua hàng có dùng voucher ko
            {
                int idVoucher = (int)Session["IDVoucher"];
                donHang = new DonHang
                {
                    MaKhachHang = makh,
                    NgayDatHang = DateTime.Now,
                    TongTien = (decimal)thanhTien,
                    MaVoucher = idVoucher,
                    TrangThai = "Đang Chờ Xử Lý",
                    GhiChu = ghichu
                };
                db.DonHangs.Add(donHang);
            }
            else
            {
                donHang = new DonHang
                {
                    MaKhachHang = makh,
                    NgayDatHang = DateTime.Now,
                    TongTien = (decimal)thanhTien,
                    TrangThai = "Đang Chờ Xử Lý",
                    GhiChu = ghichu
                };
                db.DonHangs.Add(donHang);
            }

            ChiTietDonHang ctdh = new ChiTietDonHang
            {
                MaDonHang = donHang.MaDonHang,
                MaSanPham = sanPham.MaSanPham,
                SoLuong = soluong
            };
            db.ChiTietDonHangs.Add(ctdh);

            //cập nhật số lượng trong kho
            var spKho = db.KhoHangs.FirstOrDefault(kh => kh.MaSanPham == masp);
            spKho.SoLuongTonKho -= soluong;

            db.SaveChanges();

            if (Session["IDVoucher"] != null)
            {
                //lưu vào bảng voucherKhachHang để đánh dấu là khách này đã xài mã này rồi
                int mavoucher = (int)Session["IDVoucher"];
                VoucherKhachHang vc = new VoucherKhachHang();
                vc.MaKhachHang = makh;
                vc.MaVoucher = mavoucher;
                db.VoucherKhachHangs.Add(vc);
                db.SaveChanges();
            }

            //gửi mail cho khách-------------------------------------------------------------------------------
            string content = System.IO.File.ReadAllText(Server.MapPath("~/TemplateEmail/GuiMail.html"));
            KhachHang khach = db.KhachHangs.FirstOrDefault(kh => kh.MaKhachHang == makh);
            var strSanPham = "";
            strSanPham += "<tr>";
            strSanPham += "<td style='font-weight: bold;'>" + "Tên sản phẩm" + "</td>";
            strSanPham += "<td style='font-weight: bold;'>" + "Số lượng" + "</td>";
            strSanPham += "<td style='font-weight: bold;'>" + "Tổng tiền" + "</td>";
            strSanPham += "</tr>";
            strSanPham += "<tr>";
            strSanPham += "<td>" + sanPham.TenSanPham + "</td>";
            strSanPham += "<td>" + soluong + "</td>";
            strSanPham += "<td>" + (soluong * sanPham.GiaGiam).ToString("N0") + " VNĐ" + "</td>";
            strSanPham += "</tr>";

            content = content.Replace("{{TenKhachHang}}", khach.HoTenDem + " " + khach.Ten);
            content = content.Replace("{{DienThoai}}", khach.SoDienThoai);
            content = content.Replace("{{Email}}", khach.Email);
            content = content.Replace("{{DiaChi}}", khach.DiaChi);
            content = content.Replace("{{NgayDatHang}}", DateTime.Now.ToString("dd/MM/yyyy"));
            Random rd = new Random();
            string madonhang = "#DH" + rd.Next(0, 9) + rd.Next(0, 9) + rd.Next(0, 9) + rd.Next(0, 9) + rd.Next(0, 9);
            content = content.Replace("{{MaDonHang}}", madonhang);
            content = content.Replace("{{DanhSachSanPham}}", strSanPham);
            content = content.Replace("{{ThanhTien}}", thanhTien.ToString("N0") + " VNĐ");
            string subject = "Đơn hàng " + madonhang + " đã đặt thành công";
            SendEmail(subject, content, khach.Email);

            //xoá session Voucher ko dùng nữa
            Session.Remove("DisCount");
            Session.Remove("IDVoucher");
            //xoá cảnh báo lỗi số lượng nếu trc đó người dùng đã nhập sl sai
            Session.Remove("CanhBaoSoLuong");
            return RedirectToAction("ThanhToanThanhCong");
        }

        public ActionResult ThanhToanThanhCong()
        {
            return View();
        }

        public ActionResult ThanhToanThatBai()
        {
            return View();
        }

        public ActionResult XemDonHang(string filter)
        {
            int makh = 1;
            if (Session["IDUser"] != null)
            {
                makh = (int)Session["IDUser"];
            }
            if (db.DonHangs.Where(kh => kh.MaKhachHang == makh).Count() == 0)
            {
                ViewBag.ThongBaoDonHang = "Bạn chưa có đơn hàng nào";
            }
            var donhangs = new List<DonHang>();
            if (filter == null)
            {
                donhangs = db.DonHangs.Where(kh => kh.MaKhachHang == makh).ToList();
            }

            else if (filter == "TatCa")
            {
                donhangs = db.DonHangs.Where(kh => kh.MaKhachHang == makh).ToList();
            }
            else
                donhangs = db.DonHangs.Where(kh => kh.MaKhachHang == makh && kh.TrangThai == filter).ToList();
            return View(donhangs);
        }

        public ActionResult XemChiTietDonHang(int? madonhang)
        {
            int makh = 1;
            if (Session["IDUser"] != null)
            {
                makh = (int)Session["IDUser"];
            }

            if (!madonhang.HasValue)
            {
                madonhang = 1;
            }

            var vm = new ChiTietDonHangVaKhachHangDataView();
            vm.donHang = db.DonHangs.FirstOrDefault(dh => dh.MaDonHang == madonhang);

            vm.chiTietDonHangs = db.ChiTietDonHangs.Where(ctdh => ctdh.MaDonHang == madonhang).ToList();

            vm.khachHang = db.KhachHangs.FirstOrDefault(kh => kh.MaKhachHang == makh);
            vm.tenKhachHang = vm.khachHang.HoTenDem + " " + vm.khachHang.Ten;

            //kt xem đơn này có dùng voucher ko, nếu có thì hiển thị
            var idVoucher = db.DonHangs.FirstOrDefault(dh => dh.MaDonHang == madonhang).MaVoucher;
            if (idVoucher != null)
            {
                vm.disCount = (int)db.Vouchers.FirstOrDefault(v => v.MaVoucher == idVoucher).GiamGia;
            }


            return View(vm);
        }
    }
}