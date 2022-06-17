using System.ComponentModel;

namespace Proyecto_vacunacion.Models
{
    public class ProductoO
    {

        [DisplayName("CODIGO")]
        public int codigo { get; set; }

        [DisplayName("Categoria")]
        public string categoria { get; set; }

        [DisplayName("DESCRIPCION")]
        public string descripcion { get; set; }

        [DisplayName("Nombre")]
        public string nombre { get; set; }

        [DisplayName("PRECIO S/")]
        public double precio { get; set; }

        [DisplayName("STOCK ACTUAL")]
        public int stockActual { get; set; }

        [DisplayName("Proveedor")]
        public string proveedor { get; set; }

        [DisplayName("IMAGEN DE PRODUCTO")]
        public string foto { get; set; }

    }
}
