using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;

namespace Web_MYKINGDOM.ViewModels
{
    public class ThongTinKhachHangVaGioHangViewData
    {
        public KhachHang khachHang { get; set; }
        public List<ChiTietGioHang> chiTietGioHangs { get; set; }
        public string tenKhachHang { get; set; }
    }
}