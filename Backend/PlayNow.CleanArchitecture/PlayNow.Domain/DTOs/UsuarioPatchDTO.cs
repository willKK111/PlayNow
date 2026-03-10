
using System.ComponentModel.DataAnnotations;
using PlayNow.Domain.Validators;

namespace PlayNow.Domain.DTOs
{
    public class UsuarioPatchDTO
    {
        [StringLength(100)]
        public string? Nome { get; set; }

        [StringLength(150)]
        [EmailAddress(ErrorMessage = "O campo Email deve conter um endereço de email válido.")]
        public string? Email { get; set; }

        [StringLength(255)]
        public string? Senha { get; set; }

        [Telefone(ErrorMessage = "O número de telefone deve seguir o formato (XX)XXXXX-XXXX.")]
        [StringLength(14, MinimumLength = 13, ErrorMessage = "O campo Telefone deve ter entre 13 e 14 caracteres.")]
        public string? Telefone { get; set; }


        public bool? IsAdmin { get; set; }

        public bool? Deletado { get; set; }
    }
}


