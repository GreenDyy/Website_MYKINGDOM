using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;

namespace Web_MYKINGDOM.Controllers
{
    public class VoucherController : Controller
    {
        // GET: Voucher
        MYKINGDOMEntities db = new MYKINGDOMEntities();

        [HttpPost]
        public ActionResult NhapVoucher(string InputMaVoucher)
        {
            int makh = (int)Session["IDUser"];
            var voucher = db.Vouchers.FirstOrDefault(v => v.Code == InputMaVoucher);
            if (voucher != null) //kt voucher có tồn tại k
            {
                var voucherKH = db.VoucherKhachHangs.FirstOrDefault(v => v.MaVoucher == voucher.MaVoucher && v.MaKhachHang == makh);
                if (voucherKH == null) //kt khách có dùng voucher này chưa 
                {
                    Session["DisCount"] = voucher.GiamGia;
                    Session["IDVoucher"] = voucher.MaVoucher; //dùng bên thanh toán để thêm vào đơn hàng
                    TempData["SucessMessage"] = "Nhập voucher thành công, bạn được giảm " + voucher.GiamGia + "%" + " tổng giá trị đơn hàng";
                }
                else
                {
                    TempData["FailMessage"] = "Bạn đã sử dụng voucher này rồi";
                    Session.Remove("DisCount");
                    Session.Remove("IDVoucher");
                }
                return RedirectToAction("Cart", "Cart");
            }
            else
            {
                TempData["FailMessage"] = "Voucher không hợp lệ";
                Session.Remove("DisCount");
                Session.Remove("IDVoucher");
            }
            return RedirectToAction("Cart", "Cart");
        }

        [HttpPost]
        public ActionResult NhapVoucherChoThanhToanNgay(string InputMaVoucher, ThanhToanNgayDataView vm)
        {
            int makh = (int)Session["IDUser"];
            var voucher = db.Vouchers.FirstOrDefault(v => v.Code == InputMaVoucher);
            if (voucher != null) //kt voucher có tồn tại k
            {
                var voucherKH = db.VoucherKhachHangs.FirstOrDefault(v => v.MaVoucher == voucher.MaVoucher && v.MaKhachHang == makh);
                if (voucherKH == null) //kt khách có dùng voucher này chưa 
                {
                    Session["DisCount"] = voucher.GiamGia;
                    Session["IDVoucher"] = voucher.MaVoucher; //dùng bên thanh toán để thêm vào đơn hàng
                    TempData["SucessMessage"] = "Nhập voucher thành công, bạn được giảm " + voucher.GiamGia + "%" + " tổng giá trị đơn hàng";
                }
                else
                {
                    TempData["FailMessage"] = "Bạn đã sử dụng voucher này rồi";
                    Session.Remove("DisCount");
                    Session.Remove("IDVoucher");
                }
                return RedirectToAction("ThanhToanNgay", "Order", new {masanpham = vm.sanPham.MaSanPham, soluong = vm.soLuong});
            }
            else
            {
                TempData["FailMessage"] = "Voucher không hợp lệ";
                Session.Remove("DisCount");
                Session.Remove("IDVoucher");
            }
            return RedirectToAction("ThanhToanNgay", "Order", new { masanpham = vm.sanPham.MaSanPham, soluong = vm.soLuong});
        }
    }
}