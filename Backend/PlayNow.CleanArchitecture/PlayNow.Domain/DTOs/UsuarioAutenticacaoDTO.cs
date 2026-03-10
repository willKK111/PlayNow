
namespace PlayNow.Domain.DTOs
{
    public class UsuarioAutenticacaoDTO
    {
        public int IdUsuario { get; set; }

        public string Nome { get; set; }

        public string Email { get; set; }

        public string? Telefone { get; set; }
        public bool Deletado { get; set; }
    }
}
