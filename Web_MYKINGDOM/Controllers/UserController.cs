using Antlr.Runtime.Tree;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;

namespace Web_MYKINGDOM.Controllers
{
    public class UserController : Controller
    {
        MYKINGDOMEntities db = new MYKINGDOMEntities();
        // GET: User
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult UserAccount()
        {
            if (Session["IDUser"] != null)
            {
                int makh = (int)Session["IDUser"];
                var dataUser = db.KhachHangs.Where(kh => kh.MaKhachHang == makh).FirstOrDefault();
                return View(dataUser);
            }
            return RedirectToAction("Login");
        }
        [HttpGet]
        public ActionResult EditUser()
        {
            if (Session["IDUser"] != null)
            {
                int makh = (int)Session["IDUser"];
                KhachHang khachhang = db.KhachHangs.Where(kh => kh.MaKhachHang.Equals(makh)).FirstOrDefault();
                return View(khachhang);
            }
            return RedirectToAction("Login");
        }
        [HttpPost]
        public ActionResult EditUser(KhachHang kh)
        {
            if (Session["IDUser"] != null)
            {
                if (ModelState.IsValid)
                {
                    int makh = (int)Session["IDUser"];
                    KhachHang khachhang = db.KhachHangs.Where(tk => tk.MaKhachHang.Equals(makh)).FirstOrDefault();
                    khachhang.HoTenDem = kh.HoTenDem;
                    khachhang.Ten = kh.Ten;
                    khachhang.Email = kh.Email;
                    khachhang.SoDienThoai = kh.SoDienThoai;
                    khachhang.DiaChi = kh.DiaChi;

                    db.SaveChanges();
                    TempData["ThongBao"] = " Cập nhật thông tin thành công";
                    return RedirectToAction("UserAccount");
                }
                else
                {
                    ModelState.AddModelError("", "Vui lòng nhập đầy đủ thông tin");
                    return View(kh);
                }

            }
            return RedirectToAction("Login");
        }

        [HttpGet]
        public ActionResult ChangePassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ChangePassword(ThongTinKhachHangChiTietDataView vm)
        {
            if (Session["IDUser"] != null)
            {
                if (string.IsNullOrWhiteSpace(vm.MatKhauCu) || string.IsNullOrWhiteSpace(vm.MatKhauMoi) || string.IsNullOrWhiteSpace(vm.XacNhanMatKhauMoi))
                {
                    ModelState.AddModelError("", "Vui lòng nhập đầy đủ thông tin");
                    return View();
                }

                int makh = (int)Session["IDUser"];
                TaiKhoanKhachHang taikhoan = db.TaiKhoanKhachHangs.Where(tk => tk.MaKhachHang == makh).FirstOrDefault();

                //kiểm tra mk cũ có đúng không
                if (taikhoan.MatKhau == vm.MatKhauCu)
                {
                    if (vm.MatKhauMoi == vm.XacNhanMatKhauMoi)
                    {
                        if (vm.MatKhauMoi != vm.MatKhauCu)
                        {
                            taikhoan.MatKhau = vm.MatKhauMoi;
                            db.SaveChanges();
                            TempData["ThongBao"] = " Đổi mật khẩu thành công thành công";
                            return RedirectToAction("UserAccount");
                        }
                        else
                        {
                            ModelState.AddModelError("MatKhauMoi", "Mật khẩu mới không được giống mật khẩu cũ");
                        }
                    }
                    else
                    {
                        ModelState.AddModelError("XacNhanMatKhauMoi", "Mật khẩu mới và xác nhận mật khẩu mới không khớp");
                    }
                }
                else
                {
                    ModelState.AddModelError("MatKhauCu", "Mật khẩu cũ không đúng");
                }
            }
            return View(vm);
        }

        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(TaiKhoanKhachHang account)
        {
            if (string.IsNullOrWhiteSpace(account.TaiKhoan) || string.IsNullOrWhiteSpace(account.MatKhau))
            {
                //ModelState.AddModelError("", "Vui lòng nhập đầy đủ tài khoản và mật khẩu");
                TempData["ThongBao"] = "Vui lòng nhập đầy đủ tài khoản và mật khẩu";
                return View();
            }

            var user = db.TaiKhoanKhachHangs
                .Where(kh => kh.TaiKhoan == account.TaiKhoan && kh.MatKhau == account.MatKhau)
                .FirstOrDefault();

            if (user != null)
            {
                //string HoDem = db.KhachHangs.Where(kh => kh.MaKhachHang == user.MaKhachHang).FirstOrDefault().HoTenDem;
                string Ten = db.KhachHangs.Where(kh => kh.MaKhachHang == user.MaKhachHang).FirstOrDefault().Ten;

                Session["TenKhachHang"] = Ten;
                Session["TaiKhoan"] = user.TaiKhoan;
                Session["IDUser"] = user.MaKhachHang;
                Session["CartQuantity"] = db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == user.MaKhachHang).TongSoLuongSP;
                return RedirectToAction("Index", "Home");
            }
            else
            {
                //ModelState.AddModelError("", "Tài khoản hoặc mật khẩu không chính xác");
                TempData["ThongBao"] = "Tài khoản hoặc mật khẩu không chính xác";
                return View();
            }
        }

        public ActionResult Logout()
        {
            Session.Clear();
            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(ThongTinKhachHangChiTietDataView account)
        {

            if (string.IsNullOrWhiteSpace(account.TaiKhoan) || string.IsNullOrWhiteSpace(account.MatKhauMoi) || string.IsNullOrWhiteSpace(account.XacNhanMatKhauMoi)
                || string.IsNullOrWhiteSpace(account.khachHang.HoTenDem) || string.IsNullOrWhiteSpace(account.khachHang.Ten) || string.IsNullOrWhiteSpace(account.khachHang.SoDienThoai)
                || string.IsNullOrWhiteSpace(account.khachHang.Email) || string.IsNullOrWhiteSpace(account.khachHang.DiaChi))
            {
                TempData["ThongBao"] = "Vui lòng nhập đầy đủ thông tin";
                return View();
            }

            else // nếu nhập đủ
            {
                var existingAccount = db.TaiKhoanKhachHangs.FirstOrDefault(tk => tk.TaiKhoan == account.TaiKhoan);

                if(existingAccount != null || account.MatKhauMoi != account.XacNhanMatKhauMoi || !IsValidSDT(account.khachHang.SoDienThoai) || !IsValidTen(account.khachHang.HoTenDem) 
                    || !IsValidTen(account.khachHang.Ten) || !IsValidEmail(account.khachHang.Email) || !IsValidDiaChi(account.khachHang.DiaChi))  // kiểm tra nếu có 1 điều kiện sai thì lấy lỗi từng thằng rồi hiển thị
                {
                    if (existingAccount != null)
                    {
                        //TempData["ThongBao"] = "Tài khoản đã tồn tại";
                        ModelState.AddModelError("TaiKhoan", "Tài khoản đã tồn tại");
                    }

                    if (account.MatKhauMoi != account.XacNhanMatKhauMoi)
                    {
                        //TempData["ThongBao"] = "Xác nhận mật khẩu không khớp";
                        ModelState.AddModelError("XacNhanMatKhauMoi", "Xác nhận mật khẩu không khớp");
                    }

                    if (!IsValidSDT(account.khachHang.SoDienThoai))
                    {
                        ModelState.AddModelError("khachHang.SoDienThoai", "Số điện thoại không hợp lệ");
                    }

                    if (!IsValidTen(account.khachHang.HoTenDem))
                    {
                        ModelState.AddModelError("khachHang.HoTenDem", "Họ đệm không hợp lệ");
                    }

                    if (!IsValidTen(account.khachHang.Ten))
                    {
                        ModelState.AddModelError("khachHang.Ten", "Tên không hợp lệ");
                    }

                    if (!IsValidEmail(account.khachHang.Email))
                    {
                        ModelState.AddModelError("khachHang.Email", "Email không hợp lệ");
                    }

                    if (!IsValidDiaChi(account.khachHang.DiaChi))
                    {
                        ModelState.AddModelError("khachHang.DiaChi", "Địa chỉ không hợp lệ");
                    }
                    return View();
                }
                else
                {
                    var vm = new ThongTinKhachHangChiTietDataView
                    {
                        khachHang = new KhachHang
                        {
                            HoTenDem = account.khachHang.HoTenDem,
                            Ten = account.khachHang.Ten,
                            Email = account.khachHang.Email,
                            SoDienThoai = account.khachHang.SoDienThoai,
                            DiaChi = account.khachHang.DiaChi
                        },
                        taiKhoanKhachHang = new TaiKhoanKhachHang
                        {
                            TaiKhoan = account.TaiKhoan,
                            MatKhau = account.MatKhauMoi,
                            MaKhachHang = account.khachHang.MaKhachHang,
                            HoatDong = "Hoạt động"
                        }
                    };
                    GioHang giohang = new GioHang
                    {
                        MaKhachHang = account.khachHang.MaKhachHang,
                        TongSoLuongSP = 0
                    };

                    db.KhachHangs.Add(vm.khachHang);
                    db.TaiKhoanKhachHangs.Add(vm.taiKhoanKhachHang);
                    db.GioHangs.Add(giohang);
                    db.SaveChanges();
                    return RedirectToAction("Login", "User");
                }
            }
        }

        public bool IsValidSDT(string cmnd)
        {
            if (cmnd.Length != 10)
            {
                return false;
            }

            if (!Regex.IsMatch(cmnd, @"^\d+$"))
            {
                return false;
            }
            return true;
        }

        public bool IsValidTen(string ten)
        {
            if (ten.Length > 50)
                return false;
            if (!Regex.IsMatch(ten, @"^[\p{L} ]+$")) //chữ có dấu và space
                return false;
            return true;
        }

        public bool IsValidEmail(string email)
        {
            if (string.IsNullOrEmpty(email))
                return false;
            if (!Regex.IsMatch(email, @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")) 
                return false;
            return true;
        }

        public bool IsValidDiaChi(string diachi)
        {
            if (diachi.Length > 255)
                return false;
            return true;
        }
    }
}