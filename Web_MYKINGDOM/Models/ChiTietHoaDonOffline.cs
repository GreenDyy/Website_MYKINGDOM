//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Web_MYKINGDOM.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class ChiTietHoaDonOffline
    {
        public int MaChiTietHoaDon { get; set; }
        public string MaHoaDon { get; set; }
        public Nullable<int> MaSanPham { get; set; }
        public int SoLuong { get; set; }
    
        public virtual HoaDonOffline HoaDonOffline { get; set; }
        public virtual SanPham SanPham { get; set; }
    }
}
