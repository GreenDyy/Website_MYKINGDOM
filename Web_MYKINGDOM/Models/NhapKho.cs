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
    
    public partial class NhapKho
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public NhapKho()
        {
            this.ChiTietNhapKhoes = new HashSet<ChiTietNhapKho>();
        }
    
        public int MaNhapKho { get; set; }
        public Nullable<int> MaNhanVien { get; set; }
        public System.DateTime NgayNhapKho { get; set; }
        public string TrangThai { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ChiTietNhapKho> ChiTietNhapKhoes { get; set; }
        public virtual NhanVien NhanVien { get; set; }
    }
}
