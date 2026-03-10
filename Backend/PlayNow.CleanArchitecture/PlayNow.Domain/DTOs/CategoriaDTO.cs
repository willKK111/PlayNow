
using System.ComponentModel.DataAnnotations;

namespace PlayNow.Domain.DTOs
{
    public class CategoriaDTO
    {
        [StringLength(100)]
        public string Nome { get; set; }
    }
}
