using Microsoft.AspNetCore.Mvc;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Interfaces;

namespace PlayNow.APIRest.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AutenticacaoController : ControllerBase
    {
        private readonly IAutenticacaoService _service;

        public AutenticacaoController(IAutenticacaoService service)
        {
            _service = service;
        }

        [HttpPost]
        public async Task<IActionResult> Autenticar([FromBody] AutenticacaoRequestDTO dto)
        {
            var resposta = await _service.Autenticar(dto);

            if(resposta == null)
            {
                return NotFound(new { Erro = "Email não cadastrado." });
            }

            if (!resposta.Cadastrado)
                return Unauthorized(new { Erro = "Senha incorreta." });

            return Ok(resposta);
        }
    }

}
