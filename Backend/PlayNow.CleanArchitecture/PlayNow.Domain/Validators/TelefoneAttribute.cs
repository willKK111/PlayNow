using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace PlayNow.Domain.Validators
{
    public class TelefoneAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            if(value == null) return true;

            var telefone = value.ToString();

            var regex = new Regex(@"^\(\d{2}\)\d{5}-\d{4}$");

            return regex.IsMatch(telefone);
        }
    }

}
