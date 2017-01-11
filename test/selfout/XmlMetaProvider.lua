﻿-- Generated by CSharp.lua Compiler 1.0.0.0
local System = System;
System.namespace("CSharpLua", function (namespace) 
    namespace.class("XmlMetaProvider", function (namespace) 
        namespace.class("XmlMetaModel", function (namespace) 
            namespace.class("TemplateModel", function (namespace) 
                return {};
            end);
            namespace.class("PropertyModel", function (namespace) 
                return {
                    IsAutoField = False
                };
            end);
            namespace.class("FieldModel", function (namespace) 
                return {};
            end);
            namespace.class("ArgumentModel", function (namespace) 
                return {};
            end);
            namespace.class("MethodModel", function (namespace) 
                local __ctor__;
                __ctor__ = function (this) 
                    this.ArgCount = - 1;
                    this.GenericArgCount = - 1;
                end;
                return {
                    __ctor__ = __ctor__
                };
            end);
            namespace.class("ClassModel", function (namespace) 
                return {};
            end);
            namespace.class("NamespaceModel", function (namespace) 
                return {};
            end);
            return {};
        end);
        namespace.class("MethodMetaInfo", function (namespace) 
            local Add, IsTypeMatch, IsMethodMatch, GetName, GetCodeTemplate, __ctor__;
            __ctor__ = function (this) 
                this.models_ = System.List(XmlMetaModel.MethodModel)();
            end;
            Add = function (this, model) 
                this.models_:Add(model);
            end;
            IsTypeMatch = function (this, symbol, typeString) 
                local typeSymbol = System.cast(Microsoft.CodeAnalysis.INamedTypeSymbol, symbol:getOriginalDefinition());
                local namespaceName = typeSymbol:getContainingNamespace():ToString();
                local name;
                if typeSymbol:getTypeArguments():getLength() == 0 then
                    name = ("{0}.{1}"):Format(namespaceName, symbol:getName());
                else
                    name = ("{0}.{1}^{2}"):Format(namespaceName, symbol:getName(), typeSymbol:getTypeArguments():getLength());
                end
                return name == typeString;
            end;
            IsMethodMatch = function (this, model, symbol) 
                if model.name ~= symbol:getName() then
                    return false;
                end

                if model.ArgCount ~= - 1 then
                    if symbol:getParameters():getLength() ~= model.ArgCount then
                        return false;
                    end
                end

                if model.GenericArgCount ~= - 1 then
                    if symbol:getTypeArguments():getLength() ~= model.GenericArgCount then
                        return false;
                    end
                end

                if not System.String.IsNullOrEmpty(model.RetType) then
                    if not IsTypeMatch(this, symbol:getReturnType(), model.RetType) then
                        return false;
                    end
                end

                if model.Args ~= nil then
                    if symbol:getParameters():getLength() ~= #model.Args then
                        return false;
                    end

                    local index = 0;
                    for _, parameter in System.each(symbol:getParameters()) do
                        local parameterModel = model.Args:get(index);
                        if not IsTypeMatch(this, parameter:getType(), parameterModel.type) then
                            return false;
                        end
                        index = index + 1;
                    end
                end

                return true;
            end;
            GetName = function (this, symbol) 
                if #this.models_ == 1 then
                    return First(this.models_, CSharpLua.MethodModel).Name;
                end

                local methodModel = this.models_:Find(function (i) return IsMethodMatch(this, i, symbol); end);
                return System.access(methodModel, function (default) return this.Name; end);
            end;
            GetCodeTemplate = function (this, symbol) 
                if #this.models_ == 1 then
                    return First(this.models_, CSharpLua.MethodModel).Template;
                end

                local methodModel = this.models_:Find(function (i) return IsMethodMatch(this, i, symbol); end);
                return System.access(methodModel, function (default) return this.Template; end);
            end;
            return {
                Add = Add, 
                GetName = GetName, 
                GetCodeTemplate = GetCodeTemplate, 
                __ctor__ = __ctor__
            };
        end);
        namespace.class("TypeMetaInfo", function (namespace) 
            local getModel, Field, Property, Method, GetFieldModel, GetPropertyModel, GetMethodMetaInfo, __init__, 
            __ctor__;
            __init__ = function (this) 
                this.fields_ = System.Dictionary(System.String, XmlMetaModel.FieldModel)();
                this.propertys_ = System.Dictionary(System.String, XmlMetaModel.PropertyModel)();
                this.methods_ = System.Dictionary(System.String, CSharpLua.XmlMetaProvider.MethodMetaInfo)();
            end;
            __ctor__ = function (this, model) 
                __init__(this);
                this.model_ = model;
                Field(this);
                Property(this);
                Method(this);
            end;
            getModel = function (this) 
                return this.model_;
            end;
            Field = function (this) 
                if this.model_.Fields ~= nil then
                    for _, fieldModel in System.each(this.model_.Fields) do
                        if System.String.IsNullOrEmpty(fieldModel.name) then
                            System.throw(System.ArgumentException(("type [{0}] has a field name is empty"):Format(this.model_.name)));
                        end

                        if this.fields_:ContainsKey(fieldModel.name) then
                            System.throw(System.ArgumentException(("type [{0}]'s field [{1}] is already exists"):Format(this.model_.name, fieldModel.name)));
                        end
                        this.fields_:Add(fieldModel.name, fieldModel);
                    end
                end
            end;
            Property = function (this) 
                if this.model_.Propertys ~= nil then
                    for _, propertyModel in System.each(this.model_.Propertys) do
                        if System.String.IsNullOrEmpty(propertyModel.name) then
                            System.throw(System.ArgumentException(("type [{0}] has a property name is empty"):Format(this.model_.name)));
                        end

                        if this.fields_:ContainsKey(propertyModel.name) then
                            System.throw(System.ArgumentException(("type [{0}]'s property [{1}] is already exists"):Format(this.model_.name, propertyModel.name)));
                        end
                        this.propertys_:Add(propertyModel.name, propertyModel);
                    end
                end
            end;
            Method = function (this) 
                if this.model_.Methods ~= nil then
                    for _, methodModel in System.each(this.model_.Methods) do
                        if System.String.IsNullOrEmpty(methodModel.name) then
                            System.throw(System.ArgumentException(("type [{0}] has a method name is empty"):Format(this.model_.name)));
                        end

                        local info = GetOrDefault(this.methods_, methodModel.name, nil, System.String, CSharpLua.MethodMetaInfo);
                        if info == nil then
                            info = CSharpLua.XmlMetaProvider.MethodMetaInfo();
                            this.methods_:Add(methodModel.name, info);
                        end
                        info:Add(methodModel);
                    end
                end
            end;
            GetFieldModel = function (this, name) 
                return GetOrDefault(this.fields_, name, nil, System.String, CSharpLua.FieldModel);
            end;
            GetPropertyModel = function (this, name) 
                return GetOrDefault(this.propertys_, name, nil, System.String, CSharpLua.PropertyModel);
            end;
            GetMethodMetaInfo = function (this, name) 
                return GetOrDefault(this.methods_, name, nil, System.String, CSharpLua.MethodMetaInfo);
            end;
            return {
                getModel = getModel, 
                GetFieldModel = GetFieldModel, 
                GetPropertyModel = GetPropertyModel, 
                GetMethodMetaInfo = GetMethodMetaInfo, 
                __ctor__ = __ctor__
            };
        end);
        local LoadNamespace, LoadType, GetNamespaceMapName, GetTypeName, MayHaveCodeMeta, GetTypeShortString, GetTypeShortName, GetTypeMetaInfo, 
        GetMethodName, GetMethodMapName, IsPropertyField, GetFieldCodeTemplate, GetProertyCodeTemplate, GetMethodCodeTemplate, __init__, __ctor__;
        __init__ = function (this) 
            this.namespaceNameMaps_ = System.Dictionary(System.String, System.String)();
            this.typeMetas_ = System.Dictionary(System.String, CSharpLua.XmlMetaProvider.TypeMetaInfo)();
        end;
        __ctor__ = function (this, files) 
            __init__(this);
            for _, file in System.each(files) do
                local xmlSeliz = System.Xml.Serialization.XmlSerializer(System.typeof(CSharpLua.XmlMetaProvider.XmlMetaModel));
                System.try(function () 
                    System.using(function (stream) 
                        local model = System.cast(CSharpLua.XmlMetaProvider.XmlMetaModel, xmlSeliz:Deserialize(stream));
                        if model.Namespaces ~= nil then
                            for _, namespaceModel in System.each(model.Namespaces) do
                                LoadNamespace(this, namespaceModel);
                            end
                        end
                    end, System.IO.FileStream(file, 3 --[[FileMode.Open]], 1 --[[FileAccess.Read]], 1 --[[FileShare.Read]]));
                end, function (default) 
                    local e = default;
                    System.throw(System.Exception(("load xml file wrong at {0}"):Format(file), e));
                end);
            end
        end;
        LoadNamespace = function (this, model) 
            local namespaceName = model.name;
            if System.String.IsNullOrEmpty(namespaceName) then
                System.throw(System.ArgumentException("namespace's name is empty"));
            end

            if not System.String.IsNullOrEmpty(model.Name) then
                if this.namespaceNameMaps_:ContainsKey(namespaceName) then
                    System.throw(System.ArgumentException(("namespace [{0}] is already has"):Format(namespaceName)));
                end
                this.namespaceNameMaps_:Add(namespaceName, model.Name);
            end

            if model.Classes ~= nil then
                local default;
                if not System.String.IsNullOrEmpty(model.Name) then
                    default = model.Name;
                else
                    default = namespaceName;
                end
                local name = default;
                LoadType(this, name, model.Classes);
            end
        end;
        LoadType = function (this, namespaceName, classes) 
            for _, classModel in System.each(classes) do
                local className = classModel.name;
                if System.String.IsNullOrEmpty(className) then
                    System.throw(System.ArgumentException(("namespace [{0}] has a class's name is empty"):Format(namespaceName)));
                end

                local classesfullName = (namespaceName or "") .. '.' .. (className or "");
                classesfullName = classesfullName:Replace(94 --[['^']], 95 --[['_']]);
                if this.typeMetas_:ContainsKey(classesfullName) then
                    System.throw(System.ArgumentException(("type [{0}] is already has"):Format(classesfullName)));
                end
                local info = CSharpLua.XmlMetaProvider.TypeMetaInfo(classModel);
                this.typeMetas_:Add(classesfullName, info);
            end
        end;
        GetNamespaceMapName = function (this, symbol) 
            local name = symbol:ToString();
            return GetOrDefault(this.namespaceNameMaps_, name, name, System.String, System.String);
        end;
        GetTypeName = function (this, symbol) 
            assert(symbol ~= nil);
            symbol = symbol:getOriginalDefinition();
            if symbol:getKind() == 17 --[[SymbolKind.TypeParameter]] then
                return CSharpLua.LuaAst.LuaIdentifierNameSyntax:new(1, symbol:getName());
            end

            if symbol:getKind() == 1 --[[SymbolKind.ArrayType]] then
                local arrayType = System.cast(Microsoft.CodeAnalysis.IArrayTypeSymbol, symbol);
                local elementTypeExpression = GetTypeName(this, arrayType:getElementType());
                local default;
                if arrayType:getRank() == 1 then
                    default = CSharpLua.LuaAst.LuaIdentifierNameSyntax.Array;
                else
                    default = CSharpLua.LuaAst.LuaIdentifierNameSyntax.MultiArray;
                end
                return CSharpLua.LuaAst.LuaInvocationExpressionSyntax:new(2, default, elementTypeExpression);
            end

            local namedTypeSymbol = System.cast(Microsoft.CodeAnalysis.INamedTypeSymbol, symbol);
            if namedTypeSymbol:getTypeKind() == 5 --[[TypeKind.Enum]] then
                return CSharpLua.LuaAst.LuaIdentifierNameSyntax.Int;
            end

            if IsDelegateType(namedTypeSymbol) then
                return CSharpLua.LuaAst.LuaIdentifierNameSyntax.Delegate;
            end

            local baseTypeName = GetTypeShortName(this, namedTypeSymbol);
            if namedTypeSymbol:getTypeArguments():getLength() == 0 then
                return baseTypeName;
            else
                local invocationExpression = CSharpLua.LuaAst.LuaInvocationExpressionSyntax:new(1, baseTypeName);
                for _, typeArgument in System.each(namedTypeSymbol:getTypeArguments()) do
                    local typeArgumentExpression = GetTypeName(this, typeArgument);
                    invocationExpression:AddArgument(typeArgumentExpression);
                end
                return invocationExpression;
            end
        end;
        MayHaveCodeMeta = function (this, symbol) 
            return symbol:getDeclaredAccessibility() == 6 --[[Accessibility.Public]] and not IsFromCode(symbol);
        end;
        GetTypeShortString = function (this, symbol) 
            local typeSymbol = System.cast(Microsoft.CodeAnalysis.INamedTypeSymbol, symbol:getOriginalDefinition());
            local namespaceName = GetNamespaceMapName(this, typeSymbol:getContainingNamespace());
            local name;
            if typeSymbol:getTypeArguments():getLength() == 0 then
                name = ("{0}.{1}"):Format(namespaceName, symbol:getName());
            else
                name = ("{0}.{1}_{2}"):Format(namespaceName, symbol:getName(), typeSymbol:getTypeArguments():getLength());
            end
            return name;
        end;
        GetTypeShortName = function (this, symbol) 
            local name = GetTypeShortString(this, symbol);
            if MayHaveCodeMeta(this, symbol) then
                local info = GetOrDefault(this.typeMetas_, name, nil, System.String, CSharpLua.TypeMetaInfo);
                if info ~= nil then
                    local newName = info:getModel().Name;
                    if newName ~= nil then
                        name = newName;
                    end
                end
            end
            return CSharpLua.LuaAst.LuaIdentifierNameSyntax:new(1, name);
        end;
        GetTypeMetaInfo = function (this, memberSymbol) 
            local typeName = GetTypeShortString(this, memberSymbol:getContainingType());
            return GetOrDefault(this.typeMetas_, typeName, nil, System.String, CSharpLua.TypeMetaInfo);
        end;
        GetMethodName = function (this, symbol) 
            if symbol:getDeclaredAccessibility() ~= 6 --[[Accessibility.Public]] then
                return nil;
            end

            local name = nil;
            if not IsFromCode(symbol) then
                name = System.access(GetTypeMetaInfo(this, symbol), System.access(function (default) return this:GetMethodMetaInfo; end(this, symbol:getName()), function (default) return this:GetName; end(this, symbol)));
            end

            if name == nil then
                if symbol:getIsOverride() then
                    if symbol:getOverriddenMethod() ~= nil then
                        name = GetMethodName(this, symbol:getOverriddenMethod());
                    end
                else
                    local interfaceImplementations = InterfaceImplementations(symbol, Microsoft.CodeAnalysis.IMethodSymbol);
                    if interfaceImplementations ~= nil then
                        for _, interfaceMethod in System.each(interfaceImplementations) do
                            name = GetMethodName(this, interfaceMethod);
                            if name ~= nil then
                                break;
                            end
                        end
                    end
                end
            end
            return name;
        end;
        GetMethodMapName = function (this, symbol) 
            local name = GetMethodName(this, symbol);
            return name or symbol:getName();
        end;
        IsPropertyField = function (this, symbol) 
            if MayHaveCodeMeta(this, symbol) then
                local info = System.access(GetTypeMetaInfo(this, symbol), function (default) return this:GetPropertyModel; end(this, symbol:getName()));
                return info ~= nil and info.IsAutoField;
            end
            return false;
        end;
        GetFieldCodeTemplate = function (this, symbol) 
            if MayHaveCodeMeta(this, symbol) then
                return System.access(GetTypeMetaInfo(this, symbol), System.access(function (default) return this:GetFieldModel; end(this, symbol:getName()), function (default) return this.Template; end));
            end
            return nil;
        end;
        GetProertyCodeTemplate = function (this, symbol, isGet) 
            if MayHaveCodeMeta(this, symbol) then
                local info = System.access(GetTypeMetaInfo(this, symbol), function (default) return this:GetPropertyModel; end(this, symbol:getName()));
                if info ~= nil then
                    local default;
                    if isGet then
                        default = System.access(info.get, function (default) return this.Template; end);
                    else
                        default = System.access(info.set, function (default) return this.Template; end);
                    end
                    return default;
                end
            end
            return nil;
        end;
        GetMethodCodeTemplate = function (this, symbol) 
            if symbol:getDeclaredAccessibility() ~= 6 --[[Accessibility.Public]] then
                return nil;
            end

            local codeTemplate = nil;
            if not IsFromCode(symbol) then
                codeTemplate = System.access(GetTypeMetaInfo(this, symbol), System.access(function (default) return this:GetMethodMetaInfo; end(this, symbol:getName()), function (default) return this:GetCodeTemplate; end(this, symbol)));
            end

            if codeTemplate == nil then
                if symbol:getIsOverride() then
                    if symbol:getOverriddenMethod() ~= nil then
                        codeTemplate = GetMethodCodeTemplate(this, symbol:getOverriddenMethod());
                    end
                else
                    local interfaceImplementations = InterfaceImplementations(symbol, Microsoft.CodeAnalysis.IMethodSymbol);
                    if interfaceImplementations ~= nil then
                        for _, interfaceMethod in System.each(interfaceImplementations) do
                            codeTemplate = GetMethodCodeTemplate(this, interfaceMethod);
                            if codeTemplate ~= nil then
                                break;
                            end
                        end
                    end
                end
            end
            return codeTemplate;
        end;
        return {
            GetNamespaceMapName = GetNamespaceMapName, 
            GetTypeName = GetTypeName, 
            GetTypeShortName = GetTypeShortName, 
            GetMethodMapName = GetMethodMapName, 
            IsPropertyField = IsPropertyField, 
            GetFieldCodeTemplate = GetFieldCodeTemplate, 
            GetProertyCodeTemplate = GetProertyCodeTemplate, 
            GetMethodCodeTemplate = GetMethodCodeTemplate, 
            __ctor__ = __ctor__
        };
    end);
end);
