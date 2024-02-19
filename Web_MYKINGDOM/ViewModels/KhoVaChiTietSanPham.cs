using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;

namespace Web_MYKINGDOM.ViewModels
{
    public class KhoVaChiTietSanPham
    {
        public SanPham sanPham { get; set; }
        public int? SoLuongTrongKho { get; set; }
    }
}