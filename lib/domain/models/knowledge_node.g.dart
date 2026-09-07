// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_node.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKnowledgeNodeCollection on Isar {
  IsarCollection<KnowledgeNode> get knowledgeNodes => this.collection();
}

const KnowledgeNodeSchema = CollectionSchema(
  name: r'KnowledgeNode',
  id: 3048272821976668672,
  properties: {
    r'algebraicProof': PropertySchema(
      id: 0,
      name: r'algebraicProof',
      type: IsarType.objectList,
      target: r'ProofStep',
    ),
    r'blocks': PropertySchema(
      id: 1,
      name: r'blocks',
      type: IsarType.objectList,
      target: r'ContentBlock',
    ),
    r'category': PropertySchema(
      id: 2,
      name: r'category',
      type: IsarType.string,
    ),
    r'interactiveData': PropertySchema(
      id: 3,
      name: r'interactiveData',
      type: IsarType.object,
      target: r'InteractiveData',
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'serverId': PropertySchema(
      id: 5,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'subCategory': PropertySchema(
      id: 6,
      name: r'subCategory',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _knowledgeNodeEstimateSize,
  serialize: _knowledgeNodeSerialize,
  deserialize: _knowledgeNodeDeserialize,
  deserializeProp: _knowledgeNodeDeserializeProp,
  idName: r'id',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907776,
      name: r'serverId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'prerequisites': LinkSchema(
      id: -3176454873111640576,
      name: r'prerequisites',
      target: r'KnowledgeNode',
      single: false,
    )
  },
  embeddedSchemas: {
    r'ProofStep': ProofStepSchema,
    r'ContentBlock': ContentBlockSchema,
    r'InteractiveData': InteractiveDataSchema,
    r'InteractiveParameter': InteractiveParameterSchema
  },
  getId: _knowledgeNodeGetId,
  getLinks: _knowledgeNodeGetLinks,
  attach: _knowledgeNodeAttach,
  version: '3.1.0+1',
);

int _knowledgeNodeEstimateSize(
  KnowledgeNode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.algebraicProof.length * 3;
  {
    final offsets = allOffsets[ProofStep]!;
    for (var i = 0; i < object.algebraicProof.length; i++) {
      final value = object.algebraicProof[i];
      bytesCount += ProofStepSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.blocks.length * 3;
  {
    final offsets = allOffsets[ContentBlock]!;
    for (var i = 0; i < object.blocks.length; i++) {
      final value = object.blocks[i];
      bytesCount += ContentBlockSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.category.length * 3;
  {
    final value = object.interactiveData;
    if (value != null) {
      bytesCount += 3 +
          InteractiveDataSchema.estimateSize(
              value, allOffsets[InteractiveData]!, allOffsets);
    }
  }
  bytesCount += 3 + object.serverId.length * 3;
  {
    final value = object.subCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _knowledgeNodeSerialize(
  KnowledgeNode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<ProofStep>(
    offsets[0],
    allOffsets,
    ProofStepSchema.serialize,
    object.algebraicProof,
  );
  writer.writeObjectList<ContentBlock>(
    offsets[1],
    allOffsets,
    ContentBlockSchema.serialize,
    object.blocks,
  );
  writer.writeString(offsets[2], object.category);
  writer.writeObject<InteractiveData>(
    offsets[3],
    allOffsets,
    InteractiveDataSchema.serialize,
    object.interactiveData,
  );
  writer.writeDateTime(offsets[4], object.lastUpdated);
  writer.writeString(offsets[5], object.serverId);
  writer.writeString(offsets[6], object.subCategory);
  writer.writeString(offsets[7], object.title);
}

KnowledgeNode _knowledgeNodeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KnowledgeNode();
  object.algebraicProof = reader.readObjectList<ProofStep>(
        offsets[0],
        ProofStepSchema.deserialize,
        allOffsets,
        ProofStep(),
      ) ??
      [];
  object.blocks = reader.readObjectList<ContentBlock>(
        offsets[1],
        ContentBlockSchema.deserialize,
        allOffsets,
        ContentBlock(),
      ) ??
      [];
  object.category = reader.readString(offsets[2]);
  object.id = id;
  object.interactiveData = reader.readObjectOrNull<InteractiveData>(
    offsets[3],
    InteractiveDataSchema.deserialize,
    allOffsets,
  );
  object.lastUpdated = reader.readDateTime(offsets[4]);
  object.serverId = reader.readString(offsets[5]);
  object.subCategory = reader.readStringOrNull(offsets[6]);
  object.title = reader.readString(offsets[7]);
  return object;
}

P _knowledgeNodeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<ProofStep>(
            offset,
            ProofStepSchema.deserialize,
            allOffsets,
            ProofStep(),
          ) ??
          []) as P;
    case 1:
      return (reader.readObjectList<ContentBlock>(
            offset,
            ContentBlockSchema.deserialize,
            allOffsets,
            ContentBlock(),
          ) ??
          []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<InteractiveData>(
        offset,
        InteractiveDataSchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _knowledgeNodeGetId(KnowledgeNode object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _knowledgeNodeGetLinks(KnowledgeNode object) {
  return [object.prerequisites];
}

void _knowledgeNodeAttach(
    IsarCollection<dynamic> col, Id id, KnowledgeNode object) {
  object.id = id;
  object.prerequisites
      .attach(col, col.isar.collection<KnowledgeNode>(), r'prerequisites', id);
}

extension KnowledgeNodeByIndex on IsarCollection<KnowledgeNode> {
  Future<KnowledgeNode?> getByServerId(String serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  KnowledgeNode? getByServerIdSync(String serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(String serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(String serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<KnowledgeNode?>> getAllByServerId(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<KnowledgeNode?> getAllByServerIdSync(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'serverId', values);
  }

  Future<int> deleteAllByServerId(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'serverId', values);
  }

  int deleteAllByServerIdSync(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'serverId', values);
  }

  Future<Id> putByServerId(KnowledgeNode object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(KnowledgeNode object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<KnowledgeNode> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<KnowledgeNode> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension KnowledgeNodeQueryWhereSort
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QWhere> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KnowledgeNodeQueryWhere
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QWhereClause> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause> serverIdEqualTo(
      String serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterWhereClause>
      serverIdNotEqualTo(String serverId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension KnowledgeNodeQueryFilter
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QFilterCondition> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'algebraicProof',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'algebraicProof',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'algebraicProof',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'algebraicProof',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'algebraicProof',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'algebraicProof',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      interactiveDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'interactiveData',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      interactiveDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'interactiveData',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subCategory',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subCategory',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      subCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension KnowledgeNodeQueryObject
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QFilterCondition> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      algebraicProofElement(FilterQuery<ProofStep> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'algebraicProof');
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      blocksElement(FilterQuery<ContentBlock> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'blocks');
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      interactiveData(FilterQuery<InteractiveData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'interactiveData');
    });
  }
}

extension KnowledgeNodeQueryLinks
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QFilterCondition> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisites(FilterQuery<KnowledgeNode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'prerequisites');
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisitesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prerequisites', length, true, length, true);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisitesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prerequisites', 0, true, 0, true);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisitesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prerequisites', 0, false, 999999, true);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisitesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prerequisites', 0, true, length, include);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisitesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'prerequisites', length, include, 999999, true);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterFilterCondition>
      prerequisitesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'prerequisites', lower, includeLower, upper, includeUpper);
    });
  }
}

extension KnowledgeNodeQuerySortBy
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QSortBy> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> sortBySubCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subCategory', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      sortBySubCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subCategory', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension KnowledgeNodeQuerySortThenBy
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QSortThenBy> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenBySubCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subCategory', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy>
      thenBySubCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subCategory', Sort.desc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension KnowledgeNodeQueryWhereDistinct
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QDistinct> {
  QueryBuilder<KnowledgeNode, KnowledgeNode, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QDistinct> distinctBySubCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subCategory', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KnowledgeNode, KnowledgeNode, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension KnowledgeNodeQueryProperty
    on QueryBuilder<KnowledgeNode, KnowledgeNode, QQueryProperty> {
  QueryBuilder<KnowledgeNode, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KnowledgeNode, List<ProofStep>, QQueryOperations>
      algebraicProofProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'algebraicProof');
    });
  }

  QueryBuilder<KnowledgeNode, List<ContentBlock>, QQueryOperations>
      blocksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blocks');
    });
  }

  QueryBuilder<KnowledgeNode, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<KnowledgeNode, InteractiveData?, QQueryOperations>
      interactiveDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interactiveData');
    });
  }

  QueryBuilder<KnowledgeNode, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<KnowledgeNode, String, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<KnowledgeNode, String?, QQueryOperations> subCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subCategory');
    });
  }

  QueryBuilder<KnowledgeNode, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ContentBlockSchema = Schema(
  name: r'ContentBlock',
  id: 4517901226766660096,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _contentBlockEstimateSize,
  serialize: _contentBlockSerialize,
  deserialize: _contentBlockDeserialize,
  deserializeProp: _contentBlockDeserializeProp,
);

int _contentBlockEstimateSize(
  ContentBlock object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.content;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _contentBlockSerialize(
  ContentBlock object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeString(offsets[1], object.type);
}

ContentBlock _contentBlockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContentBlock();
  object.content = reader.readStringOrNull(offsets[0]);
  object.type = reader.readStringOrNull(offsets[1]);
  return object;
}

P _contentBlockDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ContentBlockQueryFilter
    on QueryBuilder<ContentBlock, ContentBlock, QFilterCondition> {
  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentBlock, ContentBlock, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension ContentBlockQueryObject
    on QueryBuilder<ContentBlock, ContentBlock, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ProofStepSchema = Schema(
  name: r'ProofStep',
  id: -5201550155890828288,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'insight': PropertySchema(
      id: 1,
      name: r'insight',
      type: IsarType.string,
    ),
    r'latexEquation': PropertySchema(
      id: 2,
      name: r'latexEquation',
      type: IsarType.string,
    )
  },
  estimateSize: _proofStepEstimateSize,
  serialize: _proofStepSerialize,
  deserialize: _proofStepDeserialize,
  deserializeProp: _proofStepDeserializeProp,
);

int _proofStepEstimateSize(
  ProofStep object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.insight;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.latexEquation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _proofStepSerialize(
  ProofStep object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeString(offsets[1], object.insight);
  writer.writeString(offsets[2], object.latexEquation);
}

ProofStep _proofStepDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProofStep();
  object.description = reader.readStringOrNull(offsets[0]);
  object.insight = reader.readStringOrNull(offsets[1]);
  object.latexEquation = reader.readStringOrNull(offsets[2]);
  return object;
}

P _proofStepDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ProofStepQueryFilter
    on QueryBuilder<ProofStep, ProofStep, QFilterCondition> {
  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'insight',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'insight',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'insight',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition> insightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insight',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      insightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'insight',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latexEquation',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latexEquation',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latexEquation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latexEquation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latexEquation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latexEquation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'latexEquation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'latexEquation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'latexEquation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'latexEquation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latexEquation',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofStep, ProofStep, QAfterFilterCondition>
      latexEquationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'latexEquation',
        value: '',
      ));
    });
  }
}

extension ProofStepQueryObject
    on QueryBuilder<ProofStep, ProofStep, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const InteractiveDataSchema = Schema(
  name: r'InteractiveData',
  id: 7987400407099010048,
  properties: {
    r'equations': PropertySchema(
      id: 0,
      name: r'equations',
      type: IsarType.stringList,
    ),
    r'parameters': PropertySchema(
      id: 1,
      name: r'parameters',
      type: IsarType.objectList,
      target: r'InteractiveParameter',
    ),
    r'templateType': PropertySchema(
      id: 2,
      name: r'templateType',
      type: IsarType.string,
    ),
    r'unit': PropertySchema(
      id: 3,
      name: r'unit',
      type: IsarType.string,
    )
  },
  estimateSize: _interactiveDataEstimateSize,
  serialize: _interactiveDataSerialize,
  deserialize: _interactiveDataDeserialize,
  deserializeProp: _interactiveDataDeserializeProp,
);

int _interactiveDataEstimateSize(
  InteractiveData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.equations;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.parameters;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[InteractiveParameter]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += InteractiveParameterSchema.estimateSize(
              value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.templateType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.unit;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _interactiveDataSerialize(
  InteractiveData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.equations);
  writer.writeObjectList<InteractiveParameter>(
    offsets[1],
    allOffsets,
    InteractiveParameterSchema.serialize,
    object.parameters,
  );
  writer.writeString(offsets[2], object.templateType);
  writer.writeString(offsets[3], object.unit);
}

InteractiveData _interactiveDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InteractiveData();
  object.equations = reader.readStringList(offsets[0]);
  object.parameters = reader.readObjectList<InteractiveParameter>(
    offsets[1],
    InteractiveParameterSchema.deserialize,
    allOffsets,
    InteractiveParameter(),
  );
  object.templateType = reader.readStringOrNull(offsets[2]);
  object.unit = reader.readStringOrNull(offsets[3]);
  return object;
}

P _interactiveDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readObjectList<InteractiveParameter>(
        offset,
        InteractiveParameterSchema.deserialize,
        allOffsets,
        InteractiveParameter(),
      )) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension InteractiveDataQueryFilter
    on QueryBuilder<InteractiveData, InteractiveData, QFilterCondition> {
  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'equations',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'equations',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'equations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'equations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'equations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'equations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'equations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'equations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'equations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'equations',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'equations',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'equations',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'equations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'equations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'equations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'equations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'equations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      equationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'equations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parameters',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parameters',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parameters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parameters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parameters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parameters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parameters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parameters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'templateType',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'templateType',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'templateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'templateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'templateType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'templateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'templateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'templateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'templateType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateType',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      templateTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'templateType',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unit',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unit',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }
}

extension InteractiveDataQueryObject
    on QueryBuilder<InteractiveData, InteractiveData, QFilterCondition> {
  QueryBuilder<InteractiveData, InteractiveData, QAfterFilterCondition>
      parametersElement(FilterQuery<InteractiveParameter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'parameters');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const InteractiveParameterSchema = Schema(
  name: r'InteractiveParameter',
  id: 3547068895815186944,
  properties: {
    r'defaultValue': PropertySchema(
      id: 0,
      name: r'defaultValue',
      type: IsarType.double,
    ),
    r'label': PropertySchema(
      id: 1,
      name: r'label',
      type: IsarType.string,
    ),
    r'maxValue': PropertySchema(
      id: 2,
      name: r'maxValue',
      type: IsarType.double,
    ),
    r'minValue': PropertySchema(
      id: 3,
      name: r'minValue',
      type: IsarType.double,
    ),
    r'stepSize': PropertySchema(
      id: 4,
      name: r'stepSize',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(
      id: 5,
      name: r'unit',
      type: IsarType.string,
    ),
    r'variableName': PropertySchema(
      id: 6,
      name: r'variableName',
      type: IsarType.string,
    )
  },
  estimateSize: _interactiveParameterEstimateSize,
  serialize: _interactiveParameterSerialize,
  deserialize: _interactiveParameterDeserialize,
  deserializeProp: _interactiveParameterDeserializeProp,
);

int _interactiveParameterEstimateSize(
  InteractiveParameter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.label;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.unit;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.variableName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _interactiveParameterSerialize(
  InteractiveParameter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.defaultValue);
  writer.writeString(offsets[1], object.label);
  writer.writeDouble(offsets[2], object.maxValue);
  writer.writeDouble(offsets[3], object.minValue);
  writer.writeDouble(offsets[4], object.stepSize);
  writer.writeString(offsets[5], object.unit);
  writer.writeString(offsets[6], object.variableName);
}

InteractiveParameter _interactiveParameterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InteractiveParameter();
  object.defaultValue = reader.readDoubleOrNull(offsets[0]);
  object.label = reader.readStringOrNull(offsets[1]);
  object.maxValue = reader.readDoubleOrNull(offsets[2]);
  object.minValue = reader.readDoubleOrNull(offsets[3]);
  object.stepSize = reader.readDoubleOrNull(offsets[4]);
  object.unit = reader.readStringOrNull(offsets[5]);
  object.variableName = reader.readStringOrNull(offsets[6]);
  return object;
}

P _interactiveParameterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension InteractiveParameterQueryFilter on QueryBuilder<InteractiveParameter,
    InteractiveParameter, QFilterCondition> {
  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> defaultValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultValue',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> defaultValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultValue',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> defaultValueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> defaultValueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> defaultValueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> defaultValueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'label',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'label',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
          QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
          QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> maxValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxValue',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> maxValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxValue',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> maxValueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> maxValueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> maxValueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> maxValueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> minValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'minValue',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> minValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'minValue',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> minValueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> minValueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> minValueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> minValueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> stepSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stepSize',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> stepSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stepSize',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> stepSizeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> stepSizeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stepSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> stepSizeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stepSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> stepSizeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stepSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unit',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unit',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
          QAfterFilterCondition>
      unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
          QAfterFilterCondition>
      unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'variableName',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'variableName',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variableName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'variableName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'variableName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'variableName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'variableName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'variableName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
          QAfterFilterCondition>
      variableNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'variableName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
          QAfterFilterCondition>
      variableNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'variableName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variableName',
        value: '',
      ));
    });
  }

  QueryBuilder<InteractiveParameter, InteractiveParameter,
      QAfterFilterCondition> variableNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'variableName',
        value: '',
      ));
    });
  }
}

extension InteractiveParameterQueryObject on QueryBuilder<InteractiveParameter,
    InteractiveParameter, QFilterCondition> {}
