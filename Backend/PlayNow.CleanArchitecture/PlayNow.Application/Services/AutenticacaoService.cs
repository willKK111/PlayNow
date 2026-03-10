using AutoMapper;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Interfaces;

namespace PlayNow.Application.Services
{
    public class AutenticacaoService : IAutenticacaoService
    {

        private readonly IAutenticacaoRepository _repository;
        private readonly IMapper _mapper;

        public AutenticacaoService(IAutenticacaoRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<AutenticacaoResponseDTO> Autenticar(AutenticacaoRequestDTO dto)
        {
            var usuario = await _repository.BuscarPorEmail(dto.Email);

            if (usuario == null)
            {
                return null;
            }

            if (usuario.Senha != dto.Senha)
            {
                return new AutenticacaoResponseDTO
                {
                    Cadastrado = false,
                    Usuario = null,
                    IsAdmin = null
                };
            }

            var usuarioDTO = _mapper.Map<UsuarioAutenticacaoDTO>(usuario);

            return new AutenticacaoResponseDTO
            {
                Cadastrado = true,
                Usuario = usuarioDTO,
                IsAdmin = usuario.IsAdmin,
            };
        }
    }

}
