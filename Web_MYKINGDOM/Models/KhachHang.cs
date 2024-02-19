﻿//------------------------------------------------------------------------------
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
    using System.ComponentModel.DataAnnotations;

    public partial class KhachHang
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public KhachHang()
        {
            this.DonHangs = new HashSet<DonHang>();
            this.GioHangs = new HashSet<GioHang>();
            this.HoaDons = new HashSet<HoaDon>();
            this.TaiKhoanKhachHangs = new HashSet<TaiKhoanKhachHang>();
            this.VoucherKhachHangs = new HashSet<VoucherKhachHang>();
        }

        public int MaKhachHang { get; set; }
        [Required(ErrorMessage = "Họ đệm không được trống")]
        public string HoTenDem { get; set; }
        [Required(ErrorMessage = "Tên không được trống")]
        public string Ten { get; set; }
        [Required(ErrorMessage = "Email không được trống")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Số điện thoại không được trống")]
        public string SoDienThoai { get; set; }
        [Required(ErrorMessage = "Địa chỉ không được trống")]
        public string DiaChi { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DonHang> DonHangs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<GioHang> GioHangs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<HoaDon> HoaDons { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TaiKhoanKhachHang> TaiKhoanKhachHangs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VoucherKhachHang> VoucherKhachHangs { get; set; }
    }
}
