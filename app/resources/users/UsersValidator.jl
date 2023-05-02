module UsersValidator

using SearchLight, SearchLight.Validation, SearchLight.QueryBuilder

function not_empty(field::Symbol, m::T)::ValidationResult where {T<:AbstractModel}
    isempty(getfield(m, field)) &&
        return ValidationResult(invalid, :not_empty, "should not be empty")

    ValidationResult(valid)
end

function unique(field::Symbol, m::T)::ValidationResult where {T<:AbstractModel}
    ispersisted(m) && return ValidationResult(valid) # don't validate updates

    if SearchLight.count(typeof(m), where("$field = ?", getfield(m, field))) > 0
        return ValidationResult(invalid, :unique, "is already used")
    end

    ValidationResult(valid)
end

function no_spaces(field::Symbol, m::T)::ValidationResult where {T<:AbstractModel}
    occursin(' ', getfield(m, field)) &&
        return ValidationResult(invalid, :no_spaces, "should not contain spaces")

    ValidationResult(valid)
end

function basic_regex(field::Symbol, m::T)::ValidationResult where {T<:AbstractModel}
    occursin(r"^\w(?:\w|[.-](?=\w)){2,31}$", getfield(m,field)) || 
        return ValidationResult(invalid, :basic_regex, "has invalid length, characters, or character combinations")

    ValidationResult(valid)
end

end
