using AutoMapper;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;

namespace PlayNow.Application.Mappings
{
    public class EntitiesToDTOMappingProfile : Profile
    {
        public EntitiesToDTOMappingProfile()
        {
            CreateMap<Usuario, UsuarioDTO>().ReverseMap(); // converte de Usuario para UsuarioDTO e converte de UsuarioDTO para Usuario
            CreateMap<UsuarioPatchDTO, Usuario>() // converte de UsuarioPatchDTO para o Usuario 
                .ForMember(dest => dest.IsAdmin, opt => opt.Condition(src => src.IsAdmin.HasValue))
                .ForMember(dest => dest.Deletado, opt => opt.Condition(src => src.Deletado.HasValue))
                .ForAllOtherMembers(opt => opt.Condition((src, dest, srcMember) => srcMember != null));

            CreateMap<Usuario, UsuarioPatchDTO>(); // converte de Usuario para UsuarioPatchDTO
            CreateMap<Usuario, UsuarioAutenticacaoDTO>().ReverseMap(); // converte de Usuario para UsuarioAutenticacaoDTO e converte de UsuarioAutenticacaoDTO para Usuario
            CreateMap<Categoria, CategoriaDTO>().ReverseMap();  // converte de Categoria para CategoriaDTO e converte de CategoriaDTO para Categoria
            CreateMap<Quadra, QuadraDTO>().ReverseMap(); // converte de Quadra para QuadraDTO e converte de QuadraDTO para Quadra
            CreateMap<Quadra, QuadraGetDTO>()
            .ForMember(dest => dest.Categoria, opt => opt.Ignore());

            CreateMap<Reserva, ReservaDTO>()
            .ForMember(dest => dest.ListaPessoas,
                opt => opt.MapFrom(src => src.PessoasReservas.Select(p => p.Nome)))
            .ReverseMap()
            .ForMember(dest => dest.PessoasReservas,
                opt => opt.MapFrom(src => src.ListaPessoas.Select(nome => new PessoasReserva { Nome = nome })));

            CreateMap<Reserva, ReservaGetDTO>()
            .ForMember(dest => dest.ListaPessoas,
                opt => opt.MapFrom(src => src.PessoasReservas.Select(p => p.Nome)))
            .ReverseMap()
            .ForMember(dest => dest.PessoasReservas,
                opt => opt.MapFrom(src => src.ListaPessoas.Select(nome => new PessoasReserva { Nome = nome })));
        }        
    }
}
