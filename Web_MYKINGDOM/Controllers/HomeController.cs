using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.Mvc;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;

namespace Web_MYKINGDOM.Controllers
{
    public class HomeController : Controller
    {
        MYKINGDOMEntities db = new MYKINGDOMEntities();
        public ActionResult Index()
        {
            var vm = new HomeIndexDataView();
            vm.danhMucs = db.DanhMucSanPhams.Take(6).ToList();

            vm.SanPhamsTheoDanhMuc = new Dictionary<int, List<SanPham>>();
            foreach (var danhMuc in vm.danhMucs)
            {
                vm.SanPhamsTheoDanhMuc[danhMuc.MaDanhMuc] = db.SanPhams.Where(sp => sp.MaDanhMuc == danhMuc.MaDanhMuc).Take(8).ToList();
            }

            return View(vm);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}