using Microsoft.AspNetCore.Mvc;
using Proyecto_vacunacion.Models;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Session;
using Newtonsoft.Json;


namespace Proyecto_vacunacion.Controllers
{
    public class VentaProductoController : Controller
    {


        string cadena = @"server = DESKTOP-7IQJ2J4\SQLEXPRESS;database = TIENDA;Trusted_Connection = True;" +
          "MultipleActiveResultSets = True;TrustServerCertificate = False;Encrypt = False";

        
        public ActionResult Principal()
        {
            return View();
        }

        public ActionResult Comprar()
        {
            if (HttpContext.Session.GetString("carrito") == null)
            {
                return RedirectToAction("Principal");
            }

            var carrito = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            ViewBag.monto = carrito.Sum(p => p.subtotal);
            return View(carrito);


        }

        //LISTA PRODUCTO POR JSAON **
        public ActionResult ListaProducto()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {          
            
                List<ProductoO> aProductos = new List<ProductoO>();
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
            return Json(aProductos);    
            
            }

        }

        //LISTA PRODUCTO **
        List<ProductoO> ListProductos()
        {

            using (SqlConnection cn = new SqlConnection(cadena))
            {

                List<ProductoO> aProductos = new List<ProductoO>();
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
                return aProductos;

            }
        }

        //VISTA DE PRODUCTO SELECCIONADO **
        public ActionResult seleccionaProductos(int id)
        {

            if (HttpContext.Session.GetString("carrito")== null)
            {
                HttpContext.Session.SetString("carrito",JsonConvert.SerializeObject(new List<Item>()));
            }

            ProductoO objP = ListProductos().Where(a => a.codigo == id).FirstOrDefault();
            return View(objP);

        }

        //VISTA DE AGREGAR PRODUCTO SELECCIONADO A SESSION**
        public ActionResult agregarProducto(int id, int cant = 0)
        {
            var miProducto = ListProductos().Where(p => p.codigo == id).FirstOrDefault();
            Item objI = new Item()
            {
                codigo = miProducto.codigo,
                nombre = miProducto.nombre,
                descripcion = miProducto.descripcion,
                precio = miProducto.precio,
                cantidad = cant,
                foto = miProducto.foto
            };


            var miCarrito = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            miCarrito.Add(objI);

            HttpContext.Session.SetString("carrito", JsonConvert.SerializeObject(miCarrito));
            return RedirectToAction("Principal");
        }

        //METODO PARA LISTAR LOS PRODUCTOS SELECCIONADOS PARA EL CARRITO **
        public ActionResult ListaItem()
        {

            if (HttpContext.Session.GetString("carrito") == null)
            {
                return RedirectToAction("Principal");
            }
            var carrito = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            var monto = carrito.Sum(p => p.subtotal);

            return Json(carrito);


        }

        public ActionResult actualizarTotal()
        {
            if (HttpContext.Session.GetString("carrito") == null)
            {
                return RedirectToAction("Principal");
            }
            var carrito = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            var monto = carrito.Sum(p => p.subtotal);

            return Json(monto);

        }

        public ActionResult eliminaProducto(int? id = null)
        {

            if (id == null) return RedirectToAction("carritoCompras");
            var carrito = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            var item = carrito.Where(i => i.codigo == id).FirstOrDefault();
            carrito.Remove(item);
            HttpContext.Session.SetString("carrito", JsonConvert.SerializeObject(carrito));

            return Json(carrito);
        }

        //Metodo para pagar
        public ActionResult Pago()
        {
            List<Item> detalle = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            double mt = 0;
            foreach (Item it in detalle)
            {
                mt += it.subtotal;
            }
            ViewBag.mt = mt;
            return View(detalle);
        }

        public ActionResult Final(string dni, string nombres)
        {
            ViewBag.dni = dni;
            ViewBag.nombres = nombres;
            List<Item> detalle = JsonConvert.DeserializeObject<List<Item>>(HttpContext.Session.GetString("carrito"));
            double mt = 0;
            foreach (Item it in detalle)
            {
                mt += it.subtotal;
            }
            ViewBag.mt = mt;
            return View();
        }






    }
}
