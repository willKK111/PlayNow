
using PlayNow.Domain.DTOs;

namespace PlayNow.Domain.Interfaces
{
    public interface IAutenticacaoService
    {
        Task<AutenticacaoResponseDTO> Autenticar(AutenticacaoRequestDTO dto);
    }
}
