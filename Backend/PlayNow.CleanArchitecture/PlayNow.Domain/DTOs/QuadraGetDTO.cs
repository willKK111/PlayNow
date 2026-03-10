
using PlayNow.Domain.Entities;

namespace PlayNow.Domain.DTOs
{
    public class QuadraGetDTO
    {
        public int IdQuadra { get; set; }
        public string Nome { get; set; }
        public int Numero { get; set; }
        public int MaximoPessoas { get; set; }
        public Categoria Categoria { get; set; }
    }
}
