namespace Proyecto_vacunacion.Models
{
    public class Usuario
    {
        public int Id { get; set; }
        public string nombre { get; set; }
        public string apellido { get; set; }
        public string cargo { get; set; }
        public string Correo { get; set; }
        public string contraseña { get; set; }


        public string ConfirmarClave { get; set; }


    }
}