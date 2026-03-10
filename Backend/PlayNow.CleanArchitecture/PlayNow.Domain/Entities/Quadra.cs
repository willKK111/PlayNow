namespace PlayNow.Domain.Entities;

public partial class Quadra
{
    public int IdQuadra { get; set; }

    public string Nome { get; set; }

    public int Numero { get; set; }

    public int MaximoPessoas { get; set; }

    public int IdCategoria { get; set; }
}
