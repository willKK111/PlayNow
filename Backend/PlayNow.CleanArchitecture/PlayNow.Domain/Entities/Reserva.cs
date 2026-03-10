namespace PlayNow.Domain.Entities;

public partial class Reserva
{
    public int IdReserva { get; set; }

    public DateTime? DataHora { get; set; }

    public bool Cancelado { get; set; }

    public int IdQuadra { get; set; }

    public int IdUsuario { get; set; }

    public virtual ICollection<PessoasReserva> PessoasReservas { get; set; } = new List<PessoasReserva>();
}
