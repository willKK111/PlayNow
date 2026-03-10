using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IQuadraService
    {
        Task<QuadraDTO> Incluir(QuadraDTO quadraDTO);
        Task<(bool, QuadraDTO)> Alterar(int id, QuadraDTO quadraDTO);
        Task<Quadra> Excluir(int id);
        Task<QuadraGetDTO> SelecionarPorId(int id);
        Task<IEnumerable<QuadraGetDTO>> SelecionarTodos();
    }
}
