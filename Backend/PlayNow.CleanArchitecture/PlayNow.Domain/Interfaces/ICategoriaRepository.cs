using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface ICategoriaRepository
    {
        Task<Categoria> Incluir(Categoria categoria);
        Task<Categoria> Alterar(Categoria categoria);
        Task<Categoria> Excluir(int id);
        Task<Categoria> SelecionarPorId(int id);
        Task<IEnumerable<Categoria>> SelecionarTodos();
    }
}
