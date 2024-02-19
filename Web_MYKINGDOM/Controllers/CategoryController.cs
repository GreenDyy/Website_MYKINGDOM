using PagedList;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing.Printing;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using Web_MYKINGDOM.Models;
using Web_MYKINGDOM.ViewModels;

namespace Web_MYKINGDOM.Controllers
{
    public class CategoryController : Controller
    {
        MYKINGDOMEntities db = new MYKINGDOMEntities();
        public const int SOSANPHAMTRONGTRANG = 9;
        // GET: Category
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DanhMuc(int? madanhmuc, int? page, int? pageSize, string sortOrder)
        {
            if (!madanhmuc.HasValue)
            {
                madanhmuc = 1;
            }
            if(!page.HasValue) 
            {
                page = 1;
            }
            if(!pageSize.HasValue)
            {
                pageSize = SOSANPHAMTRONGTRANG;
            }

            var vm = new CategoryDanhMucDataView();
            vm.danhMucs = db.DanhMucSanPhams.ToList();
            vm.thuongHieus = db.ThuongHieux.ToList();
            vm.MaDanhMuc = madanhmuc;

            //lọc theo mã
            var listSp = db.SanPhams.Where(sp => sp.MaDanhMuc == madanhmuc);
            //lọc theo giá
            switch (sortOrder)
            {
                case "PriceAsc":
                    listSp = listSp.OrderBy(sp => sp.GiaGiam);
                    break;
                case "PriceDesc":
                    listSp = listSp.OrderByDescending(sp => sp.GiaGiam);
                    break;
                default:
                    break;
            }

            vm.sanPhamPages = listSp.ToList().ToPagedList((int)page, (int)pageSize);
            ViewBag.NamePage = db.DanhMucSanPhams.Where(dm => dm.MaDanhMuc == madanhmuc).Select(dm => dm.TenDanhMuc).FirstOrDefault();
            // Lưu giữ giá trị sắp xếp hiện tại
            ViewBag.CurrentSortOrder = sortOrder;
            return View(vm);
        }

        public ActionResult DoChoiTheoGioiTinh(string gender, int? page, int? pageSize, string sortOrder)
        {
            if (gender == null)
            {
                gender = "UNISEX";
            }
            if (!page.HasValue)
            {
                page = 1;
            }
            if (!pageSize.HasValue)
            {
                pageSize = SOSANPHAMTRONGTRANG;
            }

            var vm = new CategoryDoChoiTheoGioiTinhDataView();
            vm.danhMucs = db.DanhMucSanPhams.ToList();
            vm.thuongHieus = db.ThuongHieux.ToList();

            //lọc theo gender
            var listSp = db.SanPhams.Where(sp => sp.GioiTinh == gender);
            //lọc theo giá
            switch (sortOrder)
            {
                case "PriceAsc":
                    listSp = listSp.OrderBy(sp => sp.GiaGiam);
                    break;
                case "PriceDesc":
                    listSp = listSp.OrderByDescending(sp => sp.GiaGiam);
                    break;
                default:
                    break;
            }

            vm.sanPhamPages = listSp.ToList().ToPagedList((int)page, (int)pageSize);
            vm.GioiTinh = gender;
            ViewBag.NamePage = "GIỚI TÍNH: " + gender;
            // Lưu giữ giá trị sắp xếp hiện tại
            ViewBag.CurrentSortOrder = sortOrder;
            return View(vm);
        }

        public ActionResult DoChoiTheoThuongHieu(int? mathuonghieu, int? page, int? pageSize, string sortOrder)
        {
            if (!mathuonghieu.HasValue)
            {
                mathuonghieu = 1;
            }
            if (!page.HasValue)
            {
                page = 1;
            }
            if (!pageSize.HasValue)
            {
                pageSize = SOSANPHAMTRONGTRANG;
            }

            var vm = new CategoryDoChoiTheoThuongHieuDataView();
            vm.danhMucs = db.DanhMucSanPhams.ToList();
            vm.thuongHieus = db.ThuongHieux.ToList();

            //lọc theo brand
            var listSp = db.SanPhams.Where(sp => sp.MaThuongHieu == mathuonghieu);
            //lọc theo giá
            switch (sortOrder)
            {
                case "PriceAsc":
                    listSp = listSp.OrderBy(sp => sp.GiaGiam);
                    break;
                case "PriceDesc":
                    listSp = listSp.OrderByDescending(sp => sp.GiaGiam);
                    break;
                default:
                    break;
            }

            vm.sanPhamPages = listSp.ToList().ToPagedList((int)page, (int)pageSize);
            vm.MaThuongHieu = mathuonghieu;
            string tenThuongHieu = db.ThuongHieux.Where(th => th.MaThuongHieu == mathuonghieu).FirstOrDefault().TenThuongHieu;
            ViewBag.NamePage = "THƯƠNG HIỆU: " + tenThuongHieu;
            // Lưu giữ giá trị sắp xếp hiện tại
            ViewBag.CurrentSortOrder = sortOrder;
            return View(vm);
        }

        public ActionResult DoChoiMoi(int? page, int? pageSize, string sortOrder)
        {
            if (!page.HasValue)
            {
                page = 1;
            }
            if (!pageSize.HasValue)
            {
                pageSize = SOSANPHAMTRONGTRANG;
            }
            var vm = new CategoryDoChoiMoiDataView();
            vm.danhMucs = db.DanhMucSanPhams.ToList();
            vm.thuongHieus = db.ThuongHieux.ToList();

            var listSp = db.SanPhams.OrderByDescending(sp => sp.MaSanPham).Take(27);
            switch(sortOrder)
            {
                case "PriceAsc":
                    listSp = listSp.OrderBy(sp => sp.GiaGiam);
                    break;
                case "PriceDesc":
                    listSp = listSp.OrderByDescending(sp => sp.GiaGiam);
                    break;
                default:
                    break;
            }
            vm.sanPhamPages = listSp.ToPagedList((int)page, (int)pageSize); ;
            ViewBag.NamePage = "SẢN PHẨM MỚI";

            return View(vm);
        }

        public ActionResult TimKiemSanPham(string SearchString, int? page, int? pageSize, string sortOrder)
        {
            if (SearchString == null)
            {
                SearchString = string.Empty;
            }
            if (!page.HasValue)
            {
                page = 1;
            }
            if (!pageSize.HasValue)
            {
                pageSize = SOSANPHAMTRONGTRANG;
            }

            var vm = new CategoryDoChoiTimKiemDataView();
            vm.danhMucs = db.DanhMucSanPhams.ToList();
            vm.thuongHieus = db.ThuongHieux.ToList();

            //lọc theo SearchString
            var listSp = db.SanPhams.Where(sp => sp.TenSanPham.Contains(SearchString));
            //lọc theo giá
            switch (sortOrder)
            {
                case "PriceAsc":
                    listSp = listSp.OrderBy(sp => sp.GiaGiam);
                    break;
                case "PriceDesc":
                    listSp = listSp.OrderByDescending(sp => sp.GiaGiam);
                    break;
                default:
                    break;
            }

            vm.sanPhamPages = listSp.ToList().ToPagedList((int)page, (int)pageSize);
            vm.SearchString = SearchString;
            ViewBag.NamePage = "KẾT QUẢ TÌM KIẾM: '" + SearchString + "'";
            // Lưu giữ giá trị sắp xếp hiện tại
            ViewBag.CurrentSortOrder = sortOrder;
            ViewBag.SoSanPhamTimThay = vm.sanPhamPages.Count();
            return View(vm);
        }
    }
}