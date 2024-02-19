using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;

namespace Web_MYKINGDOM.Controllers
{
    public class ProductController : Controller
    {
        MYKINGDOMEntities db = new MYKINGDOMEntities();
        // GET: Product
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ChiTietSanPham(int? masanpham)
        {
            if(!masanpham.HasValue) 
            {
                masanpham = 1;
            }
            KhoVaChiTietSanPham vm = new KhoVaChiTietSanPham();
            vm.sanPham = db.SanPhams.FirstOrDefault(sp => sp.MaSanPham == masanpham);
            vm.SoLuongTrongKho = db.KhoHangs.FirstOrDefault(kho => kho.MaSanPham == masanpham).SoLuongTonKho;
            return View(vm);
        }
    }
}