namespace PlayNow.Domain.Entities;

public partial class Usuario
{
    public int IdUsuario { get; set; }

    public string Nome { get; set; }

    public string Email { get; set; }

    public string Senha { get; set; }

    public string? Telefone { get; set; }

    public bool IsAdmin { get; set; }

    public bool Deletado { get; set; }
}
