using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;

namespace Web_MYKINGDOM.ViewModels
{
    public class ChiTietDonHangVaKhachHangDataView
    {
        public KhachHang khachHang { get; set; }
        public DonHang donHang { get; set; }
        public List<ChiTietDonHang> chiTietDonHangs { get; set; }
        public string tenKhachHang { get; set; }
        public int? disCount { get; set; }
    }
}