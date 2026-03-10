
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IReservaService
    {
        Task<List<ReservaGetDTO>> ListarReservas();
        Task<ReservaGetDTO?> BuscarPorId(int id);
        Task<bool> QuadraDisponivel(int idQuadra, DateTime dataHora);
        Task<ReservaDTO> Incluir(ReservaDTO reservaDTO);
        Task<bool> Cancelar(int id);
        public Dictionary<string, List<string>> ObterHorariosDisponiveis(DateTime data);
    }
}
