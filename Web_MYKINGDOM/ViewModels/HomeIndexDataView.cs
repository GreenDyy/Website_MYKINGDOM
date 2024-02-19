using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Web_MYKINGDOM.Models;

namespace Web_MYKINGDOM.ViewModels
{
    public class HomeIndexDataView
    {
        public List<DanhMucSanPham> danhMucs { get; set; }
        public Dictionary<int, List<SanPham>> SanPhamsTheoDanhMuc { get; set; }
    }
}