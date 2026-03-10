using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IUsuarioRepository
    {
        Task<Usuario> Incluir(Usuario usuario);
        Task<Usuario> Alterar(Usuario usuario);
        Task<Usuario> SelecionarPorId(int id);
        Task<IEnumerable<Usuario>> SelecionarTodos();
    }
}
