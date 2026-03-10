using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlayNow.Domain.DTOs
{
    public class AutenticacaoResponseDTO
    {
        public bool Cadastrado { get; set; }
        public UsuarioAutenticacaoDTO Usuario { get; set; }
        public bool? IsAdmin {  get; set; }  
    }
}
