namespace PlayNow.Domain.Entities;

public partial class PessoasReserva
{
    public int IdPessoa { get; set; }

    public string Nome { get; set; } = null!;

    public int IdReserva { get; set; }

    public virtual Reserva IdReservaNavigation { get; set; } = null!;
}
