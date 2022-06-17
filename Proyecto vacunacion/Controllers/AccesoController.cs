using Microsoft.AspNetCore.Mvc;
using Proyecto_vacunacion.Models;
using Microsoft.AspNetCore.Session;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Security.Cryptography;
using System.Text;

namespace Proyecto_vacunacion.Controllers
{
    public class AccesoController : Controller
    {

        string cadena = @"server = DESKTOP-7IQJ2J4\SQLEXPRESS;database = TIENDA;Trusted_Connection = True;" +
          "MultipleActiveResultSets = True;TrustServerCertificate = False;Encrypt = False";
        public string sesion = "null";
        public string car = "";

        public IActionResult Login()
        {
            return View();
        }

        public ActionResult Registrar()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Registrar(Usuario oUsuario)
        {
            bool registrado;
            string mensaje;
            string cargo = "usuario";

            if (oUsuario.contraseña == oUsuario.ConfirmarClave)
            {
                oUsuario.contraseña = ConvertirSha256(oUsuario.contraseña);
            }
            else
            {
                ViewData["Mensaje"] = "Las contraseñas no coinciden";
                return View();
            }

            using (SqlConnection cn = new SqlConnection(cadena))
            {

                SqlCommand cmd = new SqlCommand("sp_RegistrarUsuario", cn);

                cmd.Parameters.AddWithValue("cargo", cargo);
                cmd.Parameters.AddWithValue("correo", oUsuario.Correo);
                cmd.Parameters.AddWithValue("contraseña", oUsuario.contraseña);
                cmd.Parameters.Add("Registrado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 100).Direction = ParameterDirection.Output;
                cmd.CommandType = CommandType.StoredProcedure;

                cn.Open();

                cmd.ExecuteNonQuery();

                registrado = Convert.ToBoolean(cmd.Parameters["Registrado"].Value);
                mensaje = cmd.Parameters["Mensaje"].Value.ToString();
            }
            ViewData["Mensaje"] = mensaje;

            if (registrado)
            {
                return RedirectToAction("Login", "Acceso");
            }
            else
            {
                return View();
            }

        }

        [HttpPost]
        public ActionResult Login(Usuario oUsuario)
        {
            oUsuario.contraseña = ConvertirSha256(oUsuario.contraseña);

            using (SqlConnection cn = new SqlConnection(cadena))
            {
                SqlCommand cmd = new SqlCommand("sp_ValidarUsuario", cn);
                cmd.Parameters.AddWithValue("correo", oUsuario.Correo);
                cmd.Parameters.AddWithValue("contraseña", oUsuario.contraseña);
                cmd.CommandType = CommandType.StoredProcedure;

                cn.Open();

                car = cmd.ExecuteScalar().ToString();
            }
            if ( car == "usuario")
            {
                
                HttpContext.Session.SetString(sesion, "usuario");
                return RedirectToAction("Seleccionar", "ECommerce");
            }else if (car == "admin")
            {
                HttpContext.Session.SetString(sesion, "admin");
                return RedirectToAction("IndexProducto", "Producto");
            }
            else
            {
                ViewData["Mensaje"] = "usuario no encontrado";
                return View();
            }
        }


        /*
        [HttpPost]
        [ActionName("Complex")]
        public ActionResult RegistrarAdmin(Usuario oUsuario)
        {
            bool registrado;
            string mensaje;
            string cargo = "admin";

            if (oUsuario.contraseña == oUsuario.ConfirmarClave)
            {
                oUsuario.contraseña = ConvertirSha256(oUsuario.contraseña);
            }
            else
            {
                ViewData["Mensaje"] = "Las contraseñas no coinciden";
                return View();
            }

            using (SqlConnection cn = new SqlConnection(cadena))
            {

                SqlCommand cmd = new SqlCommand("sp_RegistrarAdmin", cn);

                cmd.Parameters.AddWithValue("nombre", oUsuario.nombre);
                cmd.Parameters.AddWithValue("apellido", oUsuario.apellido);
                cmd.Parameters.AddWithValue("cargo", cargo);
                cmd.Parameters.AddWithValue("correo", oUsuario.Correo);
                cmd.Parameters.AddWithValue("contraseña", oUsuario.contraseña);
                cmd.Parameters.Add("Registrado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 100).Direction = ParameterDirection.Output;
                cmd.CommandType = CommandType.StoredProcedure;

                cn.Open();
                cmd.ExecuteNonQuery();

                registrado = Convert.ToBoolean(cmd.Parameters["Registrado"].Value);
                //mensaje = cmd.Parameters["Mensaje"].Value.ToString();
            }
            //ViewData["Mensaje"] = mensaje;

            return Content("1");

        }

        */


        //para encryptar las claves del usuario
        public static string ConvertirSha256(string texto)
        {
            //using System.Text;
            //using System.Security.Cryptography

            StringBuilder Sb = new StringBuilder();
            using (SHA256 hash = SHA256Managed.Create())
            {
                Encoding enc = Encoding.UTF8;
                byte[] result = hash.ComputeHash(enc.GetBytes(texto));

                foreach (byte b in result)
                    Sb.Append(b.ToString("x2"));
            }

            return Sb.ToString();
        }

        public IActionResult CerrarSession()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Acceso");
        }


    }
}
