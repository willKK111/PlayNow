namespace PlayNow.Domain.DTOs
{
    public class ReservaDTO
    {
        public DateTime DataHora { get; set; }
        public int IdQuadra { get; set; }
        public int IdUsuario { get; set; }
        public List<string> ListaPessoas { get; set; }
    }
}
