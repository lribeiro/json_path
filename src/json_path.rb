class String
  @@is_int_regex = /\A[-+]?\d+\z/
  def is_i?
    @@is_int_regex.match?(self)
  end

  def as_i(default)
    self.is_i? ? self.to_i : default
  end
end

class JSONPath
  attr_accessor :resultType
  attr_accessor :result
  attr_accessor :expression

  def initialize(arg)
    @resultType = arg && arg.resultType rescue "VALUE"
    @result = []
    @expression = normalize(arg).sub(/^\$;/,"")
  end

  def normalize(expr)
    subx = [];
    
    ex = expr.gsub(/[\['](\??\(.*?\))[\]']/){ |x| subx << $1; "[##{subx.size - 1}]"}
    ex = ex.gsub(/'?\.'?|\['?/, ";")
    ex = ex.gsub(/;;;|;;/, ";..;")
    ex = ex.gsub(/;$|'?\]|'$/, "")
    ex = ex.gsub(/#([0-9]+)/){ |x| subx[$1.to_i]}

    ex
  end

  def asPath(path)
    x = path.split(";")
    p = "$"

    i = 1
    n = x.size
    while i<n do
      p += /^[0-9*]+$/.match?(x[i]) ? ("["+x[i]+"]") : ("['"+x[i]+"']")
      i +=1
    end
    return p
  end

  def store(p, v)
    if p
      @result << (@resultType == "PATH" ? asPath(p) : v)
    end
    return !!p
  end

  def trace(expr, val, path)
    if expr && expr.size > 0
      x = expr.split(";")
      loc = x.shift
      x = x.join(";")

      if val && (Hash === val && val[loc]) 
        trace(x, val[loc], path + ";" + loc)
      elsif val && (Array === val && loc && loc.is_i? && val.size > loc.to_i)
        trace(x, val[loc.to_i], path + ";" + loc)

      elsif (loc == "*")
        walk(loc, x, val, path) do |m,l,x,v,p|
          trace("#{m};#{x}",v,p)
        end

      elsif (loc == "..")
        trace(x, val, path)
        walk(loc, x, val, path) do |m,l,x,v,p|
          case object = v[m]
          when Hash,Array
            trace("..;"+x.to_s,v[m],p.to_s+";"+m.to_s)
          end
        end

      elsif /,/.match?(loc) # [name1,name2,...]
        s=loc.split(/'?,'?/)
        i=0
        n=s.size

        while  i<n do
          trace(s[i].to_s+";"+x.to_s, val, path)
          i+=1
        end

      elsif (/^\(.*?\)$/.match?(loc)) # [(expr)]
        last_idx = path.rindex(";") + 1
        p = path[last_idx..-1]
        trace(jp_eval(loc, val, p).to_s+";"+x, val, path)

      elsif (/^\?\(.*?\)$/.match?(loc)) # [?(expr)]
        walk(loc, x, val, path) do |m,l,x,v,p| 
          if jp_eval(l.sub(/^\?\((.*?)\)$/,'\1'),v[m],m)
            trace("#{m};#{x}",v,p)
          end
        end

      elsif (/^(-?[0-9]*):(-?[0-9]*):?([0-9]*)$/.match?(loc)) # [start:end:step]  python slice syntax
        slice(loc, x, val, path)
      end
    else
      store(path, val)
    end
  end

  def walk(loc, expr, val, path)
    case val
    when Array
      val.each_with_index do |object,i|
        yield i,loc,expr,val,path
      end
    when Hash
      val.each_pair do |key,value|
        yield key,loc,expr,val,path
      end
    end
  end

  def slice(loc, expr, val, path)
    if Array === val
      len=val.size
      start=0
      size=len
      step=1

      loc.gsub(/^(-?[0-9]*):(-?[0-9]*):?(-?[0-9]*)$/) do |match|
        start = $1.to_i if $1.size > 0
        size  = $2.to_i if $2.size > 0
        step  = $3.to_i if $3.size > 0
      end

      start = (start < 0) ? [0,start+len].max : [len,start].min
      size  = (size < 0)  ? [0,size+len].max   : [len,size].min

      i = start
      while i < size
        trace(i.to_s+";"+expr.to_s, val, path)
        i += step
      end
    end
  end

  def jp_eval(x, _v, _vname)
    begin
      if _v && _v.size > 0
        case _v
        when Hash
          x.match(/@.(\w+)\s*([<=>!~]*)\s*(\d*)/)
          case
          when !$3 || $3.size == 0
            _v[$1]
          else
            value = $1 == "length" ? _v.size : _v[$1].to_i
            value.send($2,$3.to_i)
          end
        when Array
          x.match(/@.(\w+)\s*([\<\=\>\!\~\-\+]+)\s*(\d*)/)
          case
          when (!$3 || $3.size == 0) && $1 && $1.is_i?
            _v[$1.to_i]
          else
            value = case $1
            when "length"
              _v.size
            when /\A[-+]?\d+\z/
              $1.to_i
            end
            value && value.send($2,$3.to_i)
          end
        end

      end
    rescue Exception => e
      raise "jsonPath: " + e.message + ": " + x.gsub(/@/, "_v").gsub(/\^/, "_a")
    end
  end

  def on(object)
    if @expression && object && ( @resultType == "VALUE" || @resultType == "PATH")
      trace(@expression, object, "$")
      return @result || false
    end
  end
end
