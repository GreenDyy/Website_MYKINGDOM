using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Web_MYKINGDOM.Controllers
{
    public class DieuKhoanChinhSachHoTroController : Controller
    {
        // GET: DieuKhoanChinhSachHoTro
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ChinhSachGiaoHang()
        {
            return View();
        }

        public ActionResult DieuKhoanDieuKien()
        {
            return View();
        }

        public ActionResult ChinhSachBaoMat()
        { 
            return View();
        }

        public ActionResult ChinhSachBaoHanhDoiTra()
        {
            return View();
        }

        public ActionResult ChinhSachThanhToan()
        {
            return View();
        }
    }
}