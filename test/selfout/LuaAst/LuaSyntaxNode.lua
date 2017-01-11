﻿-- Generated by CSharp.lua Compiler 1.0.0.0
local System = System;
System.namespace("CSharpLua.LuaAst", function (namespace) 
    namespace.class("LuaSyntaxNode", function (namespace) 
        namespace.class("Semicolon", function (namespace) 
            local ToString;
            ToString = function (this) 
                return ";";
            end;
            return {
                ToString = ToString
            };
        end);
        namespace.class("Tokens", function (namespace) 
            local getEmpty, Semicolon, __staticCtor__;
            __staticCtor__ = function (this) 
                Semicolon = CSharpLua.LuaAst.LuaSyntaxNode.Semicolon();
                this.Semicolon = Semicolon;
            end;
            getEmpty = function () 
                return System.String.Empty;
            end;
            return {
                __inherits__ = {
                    CSharpLua.LuaAst.LuaSyntaxNode.Keyword
                }, 
                getEmpty = getEmpty, 
                __staticCtor__ = __staticCtor__
            };
        end);
        namespace.class("Keyword", function (namespace) 
            return {};
        end);
        local Render, SpecailWord, ReservedWords, SpecialReservedWords, IsReservedWord, __staticCtor__;
        __staticCtor__ = function (this) 
            this.TempIdentifiers = System.Array(System.String)("default", "extern", "ref", "out", "internal", "void", "case", "new", "object", "using", "fixed", "override", "abstract", "checked", "virtual");
            ReservedWords = System.create(System.HashSet(System.String)(), function (default) 
                default:Add("and");
                default:Add("elseif");
                default:Add("end");
                default:Add("function");
                default:Add("local");
                default:Add("nil");
                default:Add("not");
                default:Add("or");
                default:Add("repeat");
                default:Add("then");
                default:Add("until");
                default:Add("System");
                default:Add("Linq");
            end);
            SpecialReservedWords = System.create(System.HashSet(System.String)(), function (default) 
                default:Add("__add");
                default:Add("__sub");
                default:Add("__mul");
                default:Add("__div");
                default:Add("__mod");
                default:Add("__pow");
                default:Add("__umm");
                default:Add("__idiv");
                default:Add("__band");
                default:Add("__bor");
                default:Add("__bxor");
                default:Add("__bnot");
                default:Add("__shl");
                default:Add("__shr");
                default:Add("__concat");
                default:Add("__len");
                default:Add("__eq");
                default:Add("__lt");
                default:Add("__le");
                default:Add("__index");
                default:Add("__newindex");
                default:Add("__call");
                default:Add("__id__");
                default:Add("__name__");
                default:Add("__kind__");
                default:Add("__base__");
                default:Add("__ctor__");
                default:Add("__inherits__");
                default:Add("__interfaces__");
                default:Add("__default__");
            end);
            this.ReservedWords, this.SpecialReservedWords = ReservedWords, SpecialReservedWords;
        end;
        Render = function (this, renderer) 
            System.throw(System.NotSupportedException(("{0} is not override"):Format(this:GetType():getName())));
        end;
        SpecailWord = function (s) 
            return "__" .. (s or "") .. "__";
        end;
        IsReservedWord = function (identifier) 
            return ReservedWords:Contains(identifier);
        end;
        return {
            Render = Render, 
            SpecailWord = SpecailWord, 
            IsReservedWord = IsReservedWord, 
            __staticCtor__ = __staticCtor__
        };
    end);
    namespace.class("LuaSyntaxList", function (namespace) 
        return function (T) 
            local Add, AddRange;
            Add = function (this, node) 
                if node == nil then
                    System.throw(System.ArgumentNullException("node"));
                end
                this:Add(node);
            end;
            AddRange = function (this, collection) 
                for _, item in System.each(collection) do
                    if item == nil then
                        System.throw(System.ArgumentNullException("item"));
                    end
                    this:Add(item);
                end
            end;
            return {
                __inherits__ = {
                    System.List(T)
                }, 
                Add = Add, 
                AddRange = AddRange
            };
        end;
    end);
end);
