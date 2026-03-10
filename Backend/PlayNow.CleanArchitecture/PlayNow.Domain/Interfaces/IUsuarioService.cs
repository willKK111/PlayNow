using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface IUsuarioService
    {
        Task<UsuarioDTO> Incluir(UsuarioDTO usuarioDTO);
        Task<(bool, UsuarioDTO)> AlterarCompleto(int id, UsuarioDTO usuarioDTO);
        Task<(bool, UsuarioPatchDTO)> AlterarParcial(int id, UsuarioPatchDTO usuarioPatchDTO);
        Task<UsuarioPatchDTO> Excluir(int id);
        Task<Usuario> SelecionarPorId(int id);
        Task<IEnumerable<Usuario>> SelecionarTodos();
    }
}
