using System.ComponentModel.DataAnnotations;
namespace Proyecto_vacunacion.Models
{
    public class usuario
    {
        public int id { get; set; }

        [Required,StringLength(40,MinimumLength =3)]
        public string login { get; set; }

        [Required,MaxLength(10)]
        public string clave { get; set; }

        public int intentos { get; set; }

        public DateTime fbloque { get; set; }

    }
}
