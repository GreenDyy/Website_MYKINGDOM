using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;

namespace Web_MYKINGDOM.ViewModels
{
    public class ThanhToanNgayDataView
    {
        public KhachHang khachHang {  get; set; }
        public SanPham sanPham { get; set; }
        public string tenKhachHang { get; set; }
        public int soLuong { get; set; }
    }
}