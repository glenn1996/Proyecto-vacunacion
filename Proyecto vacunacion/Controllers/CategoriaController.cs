using Microsoft.AspNetCore.Mvc;
using Proyecto_vacunacion.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Proyecto_vacunacion.Controllers
{
    public class CategoriaController : Controller
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

        //LISTA CATEGORIA **
        List<Categoria> ListadoGeneralA()
        {
            using (SqlConnection cn = new SqlConnection(cadena))
            {
                List<Categoria> data = new List<Categoria>();
                SqlCommand cmd = new SqlCommand("SP_LISTACATEGORIA", cn);
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    Categoria obj = new Categoria()
                    {
                        codigo = int.Parse(dr[0].ToString()),
                        nombre = dr[1].ToString(),
                        descipcion = dr[2].ToString()
                    };
                    data.Add(obj);
                }

                cn.Close();
                return data;
            }


        }

        //LISTA CATEGORIA POR JSAON **
        public JsonResult ListaCategoria()
        {

            List<Categoria> data = new List<Categoria>();
            using (SqlConnection cn = new SqlConnection(cadena))
            {

                cn.Open();
                SqlCommand cmd = new SqlCommand("SP_LISTACATEGORIA", cn);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    Categoria obj = new Categoria()
                    {
                        codigo = int.Parse(dr[0].ToString()),
                        nombre = dr[1].ToString(),
                        descipcion = dr[2].ToString()
                    };
                    data.Add(obj);
                }
                cn.Close();
                return Json(data);
            }
        }

        //AGREGAR CATEGORIA DESDE DATATABLE **
        public ActionResult nuevoCategoria(Categoria objE)
        {

            List<SqlParameter> lista = new List<SqlParameter>()
             {

                new SqlParameter(){ParameterName="@nombre",SqlDbType=SqlDbType.VarChar,
                Value=objE.nombre},
                new SqlParameter(){ParameterName="@descripcion",SqlDbType=SqlDbType.VarChar,
                Value=objE.descipcion},
            };
            CRUD("SP_NUEVOCATEGORIA", lista);

            return Content("1");
        }

        //ACTUALIZAR CATEGORIA **
        [HttpPost]
        public ActionResult actualizaCategoria(Categoria objP)
        {

            List<SqlParameter> lista = new List<SqlParameter>()
        {
                new SqlParameter(){ ParameterName="@ID",SqlDbType=SqlDbType.Int,Value=objP.codigo},
                new SqlParameter(){ ParameterName="@nombre",SqlDbType=SqlDbType.VarChar,Value=objP.nombre},
                new SqlParameter(){ ParameterName="@descripcion",SqlDbType=SqlDbType.VarChar,Value=objP.descipcion}
        };
            CRUD("SP_ACTUALIZACATEGORIA", lista);
            return Json(lista);
        }

        //BUSCAR CATEGORIA POR CODIGO **
        public ActionResult BuscarCategoria(int? id = null)
        {

            using (SqlConnection cn = new SqlConnection(cadena))
            {
                List<Categoria> aProductos = new List<Categoria>();
                SqlCommand cmd = new SqlCommand("SP_LISTACATEGORIA", cn);
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    aProductos.Add(new Categoria()
                    {
                        codigo = int.Parse(dr[0].ToString()),
                        nombre = dr[1].ToString(),
                        descipcion = dr[2].ToString(),

                    });
                }

                Categoria objP = aProductos.Where(a => a.codigo == id).FirstOrDefault();
                return Json(objP);
            }


        }

        //ELIMINAR PROVEEDOR **
        public ActionResult eliminaCategoria(int? id = null)
        {
            Categoria objE = ListadoGeneralA().Where(e => e.codigo == id).FirstOrDefault();

            List<SqlParameter> lista = new List<SqlParameter>() {
            new SqlParameter(){ ParameterName="@ide",SqlDbType=SqlDbType.Int,
            Value=objE.codigo } };
            CRUD("SP_ELIMINACATEGORIA", lista);
            return Json(lista);
        }

    }
}
