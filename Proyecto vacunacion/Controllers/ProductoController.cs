//agregamos los using para utilizar
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Session;
using Microsoft.Data.SqlClient;
using System.Data;
using Proyecto_vacunacion.Models;

namespace Proyecto_vacunacion.Controllers
{

    public class ProductoController : Controller
    {

        string cadena = @"server = DESKTOP-7IQJ2J4\SQLEXPRESS;database = TIENDA;Trusted_Connection = True;" +
          "MultipleActiveResultSets = True;TrustServerCertificate = False;Encrypt = False";


        public ActionResult IndexProducto()
        {
            ViewBag.usuario = HttpContext.Session.GetString(new AccesoController().sesion);
            return View();
        }

        public ActionResult CrudProducto()
        {
            return View();

        }

        public ActionResult CrudProveedor()
        {
            return View();
        }

        public ActionResult CrudCategoria()
        {
            return View();
        }

        List<ProductoO> ListGeneral()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {  List<ProductoO> aProductos = new List<ProductoO>();
            SqlCommand cmd = new SqlCommand("SP_LISTAPRODUCTOS", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                aProductos.Add(new ProductoO()
                {
                    codigo = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString(),
                    descripcion = dr[2].ToString(),
                    precio = double.Parse(dr[3].ToString()),
                    stockActual = int.Parse(dr[4].ToString()),
                    categoria = dr[5].ToString(),
                    proveedor = dr[6].ToString(),
                    foto = dr[7].ToString()
                });
            }
            dr.Close();
            cn.Close();
            return aProductos;}
               
        }

        void CRUD(String proceso, List<SqlParameter> pars)
        {

            using (SqlConnection cn = new SqlConnection(cadena))
            {cn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand(proceso, cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddRange(pars.ToArray());
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
            }
            cn.Close(); }
                
        }

        public ActionResult ListaProducto()
        {

            using (SqlConnection cn = new SqlConnection(cadena))
            { List<ProductoO> aProductos = new List<ProductoO>();
            SqlCommand cmd = new SqlCommand("SP_LISTAPRODUCTOS", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                aProductos.Add(new ProductoO()
                {
                    codigo = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString(),
                    descripcion = dr[2].ToString(),
                    precio = double.Parse(dr[3].ToString()),
                    stockActual = int.Parse(dr[4].ToString()),
                    categoria = dr[5].ToString(),
                    proveedor = dr[6].ToString(),
                    foto = dr[7].ToString()

                });
            }
            dr.Close();
            cn.Close();
            return Json(aProductos); }

               
        }

        // listado de todos los proveedores en json para las paginas
        public JsonResult ObtenerProveedor()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {List<Proveedor> data = new List<Proveedor>();
            SqlCommand cmd = new SqlCommand("SP_LISTAPROVEEDOR", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Proveedor obj = new Proveedor()
                {
                    codigo = int.Parse(dr[0].ToString()),
                    nomprov = dr[1].ToString()
                };
                data.Add(obj);
            }

            cn.Close();
            return Json(data); }
                
        }

        public ActionResult nuevoProducto(Producto objE, IFormFile f)
        {
            if (f == null)
            {
                ViewBag.mensaje = "Seleccione una imagen";
                return View(objE);
            }
            if (Path.GetExtension(f.FileName) != ".jpg")
            {
                

                ViewBag.mensaje = "Debe ser .JPG";
                return View(objE);
            }

            string nombreNuevo = objE.nombre+".jpg";


            List<SqlParameter> lista = new List<SqlParameter>()
             {

               new SqlParameter(){ParameterName="@nom",SqlDbType=SqlDbType.VarChar,
                Value=objE.nombre},
                new SqlParameter(){ParameterName="@cat",SqlDbType=SqlDbType.Int,
                Value=objE.categoria},
                new SqlParameter(){ParameterName="@sto",SqlDbType=SqlDbType.Int,
                Value=objE.stockActual},
                new SqlParameter(){ParameterName="@pre",SqlDbType=SqlDbType.Money,
                Value=objE.precio },
                 new SqlParameter(){ParameterName="@des",SqlDbType=SqlDbType.VarChar,
               Value=objE.descripcion },
                  new SqlParameter(){ParameterName="@prov",SqlDbType=SqlDbType.Int,
               Value=objE.proveedor },
                new SqlParameter(){ParameterName="@fot",SqlDbType=SqlDbType.VarChar,
                Value="~/img/"+ nombreNuevo },


            };

            CRUD("SP_NUEVOPRODUCTO", lista);

            try {




                string ruta = Path.Combine("wwwroot/img/", nombreNuevo);
                using (FileStream newFile = System.IO.File.Create(ruta))
                {
                    f.CopyTo(newFile);
                    newFile.Flush();
                }
                return Content("1");

            }
            catch(Exception error) {
             
                return Content(error.ToString());
            
            }

        }

        List<Producto> ListGeneralA()
        {

            using (SqlConnection cn = new SqlConnection(cadena))
            {  List<Producto> aProductos = new List<Producto>();
            SqlCommand cmd = new SqlCommand("SP_PRODUCTO", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                aProductos.Add(new Producto()
                {
                    codigo = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString(),
                    descripcion = dr[2].ToString(),
                    precio = double.Parse(dr[3].ToString()),
                    stockActual = int.Parse(dr[4].ToString()),
                    categoria = int.Parse(dr[5].ToString()),
                    proveedor = int.Parse(dr[6].ToString()),
                    foto = dr[7].ToString()
                });
            }
            dr.Close();
            cn.Close();
            return aProductos;}
               
        }


        public ActionResult actualizaProducto(int id)
        {
            Producto objE = ListGeneralA().Where(e => e.codigo == id).FirstOrDefault();

            return View(objE);
        }

        [HttpPost]
        public ActionResult actualizaProducto(Producto objE)
        {
            // Producto objE = ListGeneralA().Where(e => e.codigo == id).FirstOrDefault();

            List<SqlParameter> lista = new List<SqlParameter>()
        {
              new SqlParameter(){ParameterName="@ide",SqlDbType=SqlDbType.Int,
              Value=objE.codigo},
             new SqlParameter(){ParameterName="@nom",SqlDbType=SqlDbType.VarChar,
                Value=objE.nombre},
                new SqlParameter(){ParameterName="@cat",SqlDbType=SqlDbType.Int,
                Value=objE.categoria},
                new SqlParameter(){ParameterName="@sto",SqlDbType=SqlDbType.Int,
                Value=objE.stockActual},
                new SqlParameter(){ParameterName="@pre",SqlDbType=SqlDbType.Money,
                Value=objE.precio },
                 new SqlParameter(){ParameterName="@des",SqlDbType=SqlDbType.VarChar,
               Value=objE.descripcion },
                  new SqlParameter(){ParameterName="@prov",SqlDbType=SqlDbType.Int,
               Value=objE.proveedor },
              new SqlParameter(){ParameterName="@fot",SqlDbType=SqlDbType.VarChar,
              Value=objE.foto }
};
            CRUD("SP_ACTUALIZAPRODUCTO", lista);
            return Json(lista);
        }

        //Metodo que busca producto segun ID
        public ActionResult BuscarProducto(int? id = null)
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {List<Producto> aProductos = new List<Producto>();
            SqlCommand cmd = new SqlCommand("SP_BUSCARPRODUCTOID", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ide", id);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                aProductos.Add(new Producto()
                {
                    codigo = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString(),
                    categoria = int.Parse(dr[2].ToString()),
                    stockActual = int.Parse(dr[3].ToString()),
                    precio = double.Parse(dr[4].ToString()),
                    descripcion = dr[5].ToString(),
                    proveedor = int.Parse(dr[6].ToString()),
                    foto = dr[7].ToString()
                });
            }

            dr.Close();
            cn.Close();

            return Json(aProductos); }
                
        }

        public JsonResult ObtenerCategoria()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            { List<Categoria> data = new List<Categoria>();
            SqlCommand cmd = new SqlCommand("SP_CATEGORIA", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Categoria obj = new Categoria()
                {
                    codigo = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString()
                };
                data.Add(obj);
            }

            cn.Close();
            return Json(data);}
                
        }

        public ActionResult eliminaProductos(int? id = null)
        {
            ProductoO objE = ListGeneral().Where(e => e.codigo == id).FirstOrDefault();

            List<SqlParameter> lista = new List<SqlParameter>() {
            new SqlParameter(){ ParameterName="@ide",SqlDbType=SqlDbType.Int,
            Value=objE.codigo
            }
            };
            CRUD("SP_ELIMINAPRODUCTO", lista);
            return Json(lista);
        }

    }
}
