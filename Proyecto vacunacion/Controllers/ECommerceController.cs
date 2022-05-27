using Microsoft.AspNetCore.Mvc;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Session;
using Newtonsoft.Json; //serializa/deserializa como cadena json
using Proyecto_vacunacion.Models;

namespace Proyecto_vacunacion.Controllers
{
    public class ECommerceController : Controller
    {

        string cadena = @"server = DESKTOP-7IQJ2J4\SQLEXPRESS;database = Negocios2022;Trusted_Connection = True;" +
           "MultipleActiveResultSets = True;TrustServerCertificate = False;Encrypt = False";


        IEnumerable<Producto> listado()
        {
            List<Producto> temporal = new List<Producto>();
            using (SqlConnection cn = new SqlConnection(cadena))

            {

                SqlCommand cmd = new SqlCommand("exec usp_productos", cn);
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())

                {
                    temporal.Add(new Producto()
                    {

                        idproducto = dr.GetInt32(0),
                        descripcion = dr.GetString(1),
                        categoria = dr.GetString(2),
                        precio = dr.GetDecimal(3),
                        stock = dr.GetInt32(4),

                    });
                }
            }
            return temporal;
        }

        Producto Buscar(int codigo = 0)
        {
            return listado().FirstOrDefault(c => c.idproducto == codigo);
        }



        public IActionResult Portal()
        {
            //evaluo, si no existe Session canasta, definirlo como una lista de Registro vacio
            if (HttpContext.Session.GetString("canasta") == null)
            {
                HttpContext.Session.SetString("canasta",JsonConvert.SerializeObject(new List<Registro>()));
            }
            //envio la lista de productos a la vista 
            return View(listado());

        }


        public IActionResult Seleccionar(int id = 0)
        {
            //llama al metodo buscar 
            Producto reg = Buscar(id);

            if (reg == null)

            {
                return RedirectToAction("Portal");
            }else
            {
                //envia a la vista el producto biscado por id
                return View(reg);
            }
        }


        [HttpPost]
        public IActionResult Seleccionar(int codigo, int cantidad)
        {
            //buscar el producto por su idproducto
            Producto reg = Buscar(codigo);
            //en el modelo registro amalaceno los valores de prodcuto buscado por su id y la cantidad 
            Registro item = new Registro()
            {
                idproducto = reg.idproducto,
                descripcion = reg.descripcion,
                categoria = reg.categoria,
                precio = reg.precio,
                cantidad = cantidad

            };
            //obtiene la info que esta guardad en la session de registro con GetString pero no hay nada aun 
            List<Registro> auxiliar = JsonConvert.DeserializeObject<List<Registro>>(
              HttpContext.Session.GetString("canasta"));

            //agregamos al array auxiliar el objeto registro
            auxiliar.Add(item);

            //volver formato jason el array auxiliar y da a la session un objeto registro con SetString ahora si con infomacion 
            HttpContext.Session.SetString("canasta", JsonConvert.SerializeObject(auxiliar));
            ViewBag.mensaje = "Producto Agregado";
            // enviamos a la vista el producto 
            return View(reg); 

        }


        public IActionResult Canasta()

        {

            //obtiene la info que esta guardad en la session de registro con GetString

            List<Registro> auxiliar = JsonConvert.DeserializeObject<List<Registro>>(

              HttpContext.Session.GetString("canasta"));



            //si auxiliar esta vacio, regresar al Portal

            if (auxiliar.Count == 0)

                return RedirectToAction("Portal");

            else

                return View(auxiliar);

        }


    }
}
