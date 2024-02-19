using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace Web_MYKINGDOM.ViewModels
{
    public class ThongTinKhachHangChiTietDataView
    {
        public KhachHang khachHang { get; set; }
        public TaiKhoanKhachHang taiKhoanKhachHang { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập mật khẩu cũ")]
        public string MatKhauCu { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập mật khẩu mới")]
        public string MatKhauMoi { get; set; }
        [Required(ErrorMessage = "Vui lòng xác nhận mật khẩu mới")]
        public string XacNhanMatKhauMoi { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập tài khoản")]
        public string TaiKhoan {  get; set; } // cái này dùng cho register thôi
    }
}