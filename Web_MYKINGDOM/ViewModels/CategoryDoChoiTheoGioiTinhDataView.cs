using PagedList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;

namespace Web_MYKINGDOM.ViewModels
{
    public class CategoryDoChoiTheoGioiTinhDataView
    {
        public List<DanhMucSanPham> danhMucs { get; set; }
        public IPagedList<SanPham> sanPhamPages { get; set; }
        public string GioiTinh { get; set; }
        public List<ThuongHieu> thuongHieus { get; set; }
    }
}