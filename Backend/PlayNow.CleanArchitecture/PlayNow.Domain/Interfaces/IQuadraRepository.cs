using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IQuadraRepository
    {
        Task<Quadra> Incluir(Quadra quadra);
        Task<Quadra> Alterar(Quadra quadra);
        Task<Quadra> Excluir(int id);
        Task<Quadra> SelecionarPorId(int id);
        Task<IEnumerable<Quadra>> SelecionarTodos();
    }
}
