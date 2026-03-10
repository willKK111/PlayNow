
using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IReservaRepository
    {
        Task<List<Reserva>> ListarReservas();
        Task<Reserva?> BuscarPorId(int id);
        Task<bool> QuadraDisponivel(int idQuadra, DateTime dataHora);
        Task<Reserva> Incluir(Reserva reserva);
        Task<bool> Cancelar(int id);

        public Dictionary<string, List<string>> ObterHorariosDisponiveis(DateTime data);
    }
}
