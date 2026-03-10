
namespace PlayNow.Domain.DTOs
{
    public class ReservaGetDTO
    {
        public int IdReserva { get; set; }
        public DateTime DataHora { get; set; }
        public bool Cancelado { get; set; }
        public int IdQuadra { get; set; }
        public int IdUsuario { get; set; }
        public List<string> ListaPessoas { get; set; }
    }
}
