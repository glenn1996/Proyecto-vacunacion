//agregamos los using para utilizar
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Session;
using Microsoft.Data.SqlClient;
using System.Data;
using Proyecto_vacunacion.Models;
using System.Text;
using System.Security.Cryptography;

namespace Proyecto_vacunacion.Controllers
{

    public class ProveedorController : Controller
    {

        string cadena = @"server = DESKTOP-7IQJ2J4\SQLEXPRESS;database = TIENDA;Trusted_Connection = True;" +
          "MultipleActiveResultSets = True;TrustServerCertificate = False;Encrypt = False";


        //PROCESO DE ACTUALIZAR O REGISTRAR **
        void CRUD(String proceso, List<SqlParameter> pars)
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                cn.Open();
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
                cn.Close();
            }

               
        }

        //LISTA PROVEEDOR **
        List<Usuario> ListadoGeneralA()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {
             List<Usuario> data = new List<Usuario>();
            SqlCommand cmd = new SqlCommand("SP_LISTAADMIN", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Usuario obj = new Usuario()
                {
                    Id = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString(),
                    apellido = dr[2].ToString(),
                    cargo = dr[3].ToString(),
                    Correo = dr[4].ToString(),
                    contraseña = dr[5].ToString()
                };
                data.Add(obj);
            }

            cn.Close();
            return data;
            } 

               
        }

        //LISTA PROVEEDOR POR JSAON **
        public JsonResult ListaProveedor()
        {

            List<Usuario> data = new List<Usuario>();
            using (SqlConnection cn = new SqlConnection(cadena))
            {

                cn.Open();
                SqlCommand cmd = new SqlCommand("SP_LISTAADMIN", cn);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    Usuario obj = new Usuario()
                    {
                        Id = int.Parse(dr[0].ToString()),
                        nombre = dr[1].ToString(),
                        apellido = dr[2].ToString(),
                        cargo  = dr[3].ToString(),
                        Correo = dr[4].ToString(),
                        contraseña = dr[5].ToString()
                    };
                    data.Add(obj);
                }
                cn.Close();
                return Json(data);
            }          
        }

        //AGREGAR PROVEEDOR DESDE DATATABLE **
        public ActionResult nuevoProveedor(Usuario objE)
        {
            string contra = ConvertirSha256(objE.contraseña);
            string cargo = "admin";

            List<SqlParameter> lista = new List<SqlParameter>()
             {
                
                new SqlParameter(){ParameterName="@nombre",SqlDbType=SqlDbType.VarChar,
                Value=objE.nombre},
                new SqlParameter(){ParameterName="@apellido",SqlDbType=SqlDbType.VarChar,
                Value=objE.apellido},
                new SqlParameter(){ParameterName="@cargo",SqlDbType=SqlDbType.VarChar,
                Value=cargo},
                new SqlParameter(){ParameterName="@correo",SqlDbType=SqlDbType.VarChar,
                Value=objE.Correo },
                 new SqlParameter(){ParameterName="@contraseña",SqlDbType=SqlDbType.VarChar,
               Value=contra },
            };
            CRUD("SP_NUEVOADMIN", lista);

            return Content("1");
        }

        //ACTUALIZAR PROVEEDOR **
        [HttpPost]
        public ActionResult actualizaProveedor(Usuario objP)
        {
            string contra = ConvertirSha256(objP.contraseña);
            string cargo = "admin";

            List<SqlParameter> lista = new List<SqlParameter>()
        {
                new SqlParameter(){ ParameterName="@ID",SqlDbType=SqlDbType.Int,Value=objP.Id},
                new SqlParameter(){ ParameterName="@nombre",SqlDbType=SqlDbType.VarChar,Value=objP.nombre},
                new SqlParameter(){ ParameterName="@apellido",SqlDbType=SqlDbType.VarChar,Value=objP.apellido},
                new SqlParameter(){ ParameterName="@cargo",SqlDbType=SqlDbType.VarChar,Value=cargo},
                new SqlParameter(){ ParameterName="@correo",SqlDbType=SqlDbType.VarChar,Value=objP.Correo},
                new SqlParameter(){ ParameterName="@contraseña",SqlDbType=SqlDbType.VarChar,Value=contra}
        };
            CRUD("SP_ACTUALIZAADMIN", lista);
            return Json(lista);
        }


        //BUSCAR PROVEEEDOR POR CODIGO **
        public ActionResult BuscarProveedor(int? id = null)
        {

            using (SqlConnection cn = new SqlConnection(cadena))
            { List<Usuario> aProductos = new List<Usuario>();
            SqlCommand cmd = new SqlCommand("SP_LISTAADMIN", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                aProductos.Add(new Usuario()
                {
                    Id = int.Parse(dr[0].ToString()),
                    nombre = dr[1].ToString(),
                    apellido = dr[2].ToString(),
                    cargo = dr[3].ToString(),
                    Correo = dr[4].ToString(),
                    contraseña = dr[5].ToString(),

                });
            }

            Usuario objP = aProductos.Where(a => a.Id == id).FirstOrDefault();
            return Json(objP);}

                
        }


        //ELIMINAR PROVEEDOR **
        public ActionResult eliminaProveedor(int? id = null)
        {
            Usuario objE = ListadoGeneralA().Where(e => e.Id == id).FirstOrDefault();

            List<SqlParameter> lista = new List<SqlParameter>() {
            new SqlParameter(){ ParameterName="@ide",SqlDbType=SqlDbType.Int,
            Value=objE.Id } };
            CRUD("SP_ELIMINAADMN", lista);
            return Json(lista);
        }


        //PARA ENCRYPTAR LAS CLAVES DEL USUARIO **
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

    }
}
