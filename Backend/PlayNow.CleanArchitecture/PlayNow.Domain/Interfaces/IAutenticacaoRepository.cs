using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IAutenticacaoRepository
    {
        Task<Usuario> BuscarPorEmail(string email);
    }
}
