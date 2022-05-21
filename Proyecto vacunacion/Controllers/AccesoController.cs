using Microsoft.AspNetCore.Mvc;
//agregamos los using para utilizar
using Microsoft.AspNetCore.Session;
using Microsoft.Data.SqlClient;
using System.Data;
using Proyecto_vacunacion.Models;

namespace Proyecto_vacunacion.Controllers
{
    public class AccesoController : Controller
    {
        // -----------------------> agregamos las Session que utlizaremos en el program.cs

        //key del Session
        string sesion = "";
        //cadena de acceso 
        string cadena = @"server = DESKTOP-7IQJ2J4\SQLEXPRESS;database = pon_el_hombro;Trusted_Connection = True;" +
           "MultipleActiveResultSets = True;TrustServerCertificate = False;Encrypt = False";

        // metodo para buscar usuario por su login y clave
        string verifica(string login, string clave)
        {
            string sw = "";
            //ingresamos nuestra cadena de acceso a la bd
            using (SqlConnection cn = new SqlConnection(cadena))

            {
                cn.Open();

                //ejecutar el procedure usp_verifica_acceso, pasando sus parametros de entrada y salida
                SqlCommand cmd = new SqlCommand("usp_verifica_acceso", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                //1 parametro
                cmd.Parameters.AddWithValue("@login", login);
                //2 parametro
                cmd.Parameters.AddWithValue("@clave", clave);
                //3 parametro de salida
                cmd.Parameters.Add("@sw", SqlDbType.VarChar, 1).Direction = ParameterDirection.Output;
                //4 parametro de salida
                cmd.Parameters.Add("@fullname", SqlDbType.VarChar, 150).Direction = ParameterDirection.Output;

                cmd.ExecuteNonQuery();

                //se obtiene el sw que entregara el procedure del cmd
                sw = cmd.Parameters["@sw"].Value.ToString();

                //se obtiene el nombre completo que entrega el procedure del cmd si se encuentra el usuario ingresado
                //se le entrega al session lo que contiene el parametro 
                HttpContext.Session.SetString(sesion, cmd.Parameters["@fullname"].Value.ToString());

            }
            //retorna el numero que contiene el sw ya convertido en string
            return sw;

        }


        public async Task<IActionResult> Logueo()
        {
            //inicializar el Session 
            HttpContext.Session.SetString(sesion, "");

            //envio un nuevo usuario
            return View(await Task.Run(() => new usuario()));
        }


        [HttpPost]
        public async Task<IActionResult> Logueo(usuario reg)
        {

            //valido si los datos ingresados en los input correcto
            if (!ModelState.IsValid) return View(await Task.Run(() => reg));

            //si el usuario es correcto el metodo verifica nos dara un sw que es de string
            //del objeto reg se obtiene el login y clave para ingresarolo al verificar
            string sw = verifica(reg.login, reg.clave);

            // si el sw es igual a 0
            if (sw == "0")

            {
                //nos retorna el mesaje de error que contiene la varible "sesion" que iniciamos sobre la cadena de acceso a la bd
                ModelState.AddModelError("", HttpContext.Session.GetString(sesion));
                return View(await Task.Run(() => reg));
            }

            // si es 1 el sw nos retorna a una vista plataforma 
            else
            {
                return RedirectToAction("Plataforma");
            }
        }


        public IActionResult Plataforma()
        {
            //enviar los datos del usuario
            ViewBag.usuario = HttpContext.Session.GetString(sesion);
            return View();

        }


        public IActionResult Index()
        {
            return View();
        }
    }
}
