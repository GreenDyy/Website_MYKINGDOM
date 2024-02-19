using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;

namespace Web_MYKINGDOM.Controllers
{
    public class CartController : Controller
    {
        MYKINGDOMEntities db = new MYKINGDOMEntities();
        // GET: Cart
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Cart()
        {
            if (Session["IDUser"] != null)
            {
                int makh = (int)Session["IDUser"];
                int magiohang = db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == makh).MaGioHang; 
                int soSPTrongGio = db.ChiTietGioHangs.Where(ctgh => ctgh.MaGioHang == magiohang).Count();

                if (soSPTrongGio > 0)
                {
                    var chiTietGioHang = db.ChiTietGioHangs.Where(ctgh => ctgh.MaGioHang == magiohang).ToList();
                    return View(chiTietGioHang);
                }
                else
                {
                    ViewBag.ErrorNoProduct = "Không có sản phẩm trong giỏ hàng";
                    return View();
                }
            }
            ViewBag.ErrorNoLogin = "Vui lòng đăng nhập để mua sắm";
            return View();
        }

        [HttpPost]
        public ActionResult ThemVaoGioHang(int masanpham, int soluong)
        {
            int makh = (int)Session["IDUser"];
            var gioHang = db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == makh);
            int magiohang = gioHang.MaGioHang;

            //kiểm tra số lượng thêm so với số lượng trong kho
            var soLuongTrongKho = db.KhoHangs.FirstOrDefault(kh => kh.MaSanPham == masanpham).SoLuongTonKho;
            if(soluong > soLuongTrongKho)
            {
                Session["CanhBaoSoLuong"] = "Không đủ số lượng trong kho";
                return RedirectToAction("ChiTietSanPham", "Product", new { masanpham });
            }

            var sanPhamDaCoTrongGioHang = db.ChiTietGioHangs.FirstOrDefault(ctgh => ctgh.MaGioHang == magiohang && ctgh.MaSanPham == masanpham); 
            if(sanPhamDaCoTrongGioHang != null) //kiểm tra sản phẩm có trong giỏ chưa, nếu có rồi thì khi thêm lại sp đó cập nhật lại sl
            {
                gioHang.TongSoLuongSP -= sanPhamDaCoTrongGioHang.SoLuong; //xoá sl cũ
                sanPhamDaCoTrongGioHang.SoLuong = soluong; // cập nhật lại
                gioHang.TongSoLuongSP += sanPhamDaCoTrongGioHang.SoLuong; //cộng lại
            }
            else 
            {
                var chitietgiohang = new ChiTietGioHang
                {
                    MaGioHang = magiohang,
                    MaSanPham = masanpham,
                    SoLuong = soluong
                };
                gioHang.TongSoLuongSP += chitietgiohang.SoLuong; 
                db.ChiTietGioHangs.Add(chitietgiohang);
            }
            db.SaveChanges();
            Session["CartQuantity"] = gioHang.TongSoLuongSP; // cập nhật số lượng sp trong giỏ hàng
            Session.Remove("CanhBaoSoLuong"); //xoá cảnh báo lỗi số lượng nếu trc đó người dùng đã nhập sl sai
            return RedirectToAction("ChiTietSanPham", "Product", new { masanpham });
        }
        [HttpPost]
        public ActionResult XoaKhoiGioHang(int masanpham)
        {
            int makh = (int)Session["IDUser"];
            var gioHang = db.GioHangs.FirstOrDefault(gh => gh.MaKhachHang == makh);
            int magiohang = gioHang.MaGioHang;

            var sanPhamDaCoTrongGioHang = db.ChiTietGioHangs.FirstOrDefault(ctgh => ctgh.MaGioHang == magiohang && ctgh.MaSanPham == masanpham);
            if (sanPhamDaCoTrongGioHang != null) //kiểm tra sản phẩm có trong giỏ chưa
            {
                db.ChiTietGioHangs.Remove(sanPhamDaCoTrongGioHang);
                gioHang.TongSoLuongSP -= sanPhamDaCoTrongGioHang.SoLuong;
                db.SaveChanges();

            }
            Session["CartQuantity"] = gioHang.TongSoLuongSP; // cập nhật số lượng sp trong giỏ hàng
            return RedirectToAction("GioHang");
        }
    }
}